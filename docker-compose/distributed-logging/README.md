### This docker compose file is used to setup a distributed logging system .
Technologies used in this setup are:

* Docker-compose
* Grafana(For visualization)
* Loki(For log aggregation)
* Alloy(For log collection)
* MinIO(For storage)

## Architecture

![img_1.png](img_1.png)

### Dependencies
Enable actuator in the spring boot application
```
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```
## Docker compose file

### Extract logs from spring boot application using alloy
```yaml
services:  
  alloy:
    image: grafana/alloy:v1.0.0
    container_name: alloy
    volumes:
      - ./alloy/alloy-config.yaml:/etc/alloy/config.alloy:ro
      - /var/run/docker.sock:/var/run/docker.sock
    command: run --server.http.listen-addr=0.0.0.0:12345 --storage.path=/var/lib/alloy/data /etc/alloy/config.alloy
    ports:
      - 12345:12345
    depends_on:
      - gateway
    networks:
      - your-network
```
### Aggregate logs from multiple services using loki
```yaml
services:
  write:
  image: grafana/loki:latest
  container_name: write
  command: "-config.file=/etc/loki/config.yaml -target=write"
  ports:
    - 3102:3100
    - 7946
    - 9095
  volumes:
    - ./loki/loki-config.yaml:/etc/loki/config.yaml
  healthcheck:
    test: [ "CMD-SHELL", "wget --no-verbose --tries=1 --spider http://localhost:3100/ready || exit 1" ]
    interval: 10s
    timeout: 5s
    retries: 5
  depends_on:
    - minio
  networks:
    - your-network
```
### Store logs in minio
```yaml
services:
    minio:
    image: minio/minio:latest
    restart: unless-stopped
    container_name: minio
    entrypoint:
      - sh
      - -euc
      - |
        mkdir -p /data/loki-data && \
        mkdir -p /data/loki-ruler && \
        minio server /data
    command: -c 'mkdir -p /export/loki && minio server /export'
    environment:
      - MINIO_ROOT_USER=loki
      - MINIO_ROOT_PASSWORD=supersecret
      - MINIO_PROMETHEUS_AUTH_TYPE=public
      - MINIO_UPDATE=off
    ports:
      - 9000:9000
      - 9001:9001
    volumes:
      - ./.data/minio:/data
    healthcheck:
      test: ["CMD", "mc", "ready", "local"]
      interval: 15s
      timeout: 20s
      retries: 5
    networks:
      - your-network
```      
### Read logs using loki
```yaml
services:
  read:
    image: grafana/loki:latest
    container_name: read
    command: "-config.file=/etc/loki/config.yaml -target=read"
    ports:
      - 3101:3100
      - 7946
      - 9095
    volumes:
        - ./loki/loki-config.yaml:/etc/loki/config.yaml
    depends_on:
      - minio
    healthcheck:
      test: [ "CMD-SHELL", "wget --no-verbose --tries=1 --spider http://localhost:3100/ready || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5
    networks:
      - your-network
```
### Backend loki service 
```yaml
services:
  backend:
    image: grafana/loki:latest
    container_name: backend
    volumes:
      - ./loki/loki-config.yaml:/etc/loki/config.yaml
    ports:
      - "3100"
      - "7946"
    command: "-config.file=/etc/loki/config.yaml -target=backend -legacy-read-mode=false"
    depends_on:
      - gateway
    networks:
      - your-network
```
### Gateway service to handle all http requests
```yaml
services:
  gateway:
    image: nginx:1.25.5
    container_name: gateway
    depends_on:
      - read
      - write
    entrypoint:
      - sh
      - -euc
      - |
        cat <<EOF > /etc/nginx/nginx.conf
        user  nginx;
        worker_processes  5;  ## Default: 1
        
        events {
          worker_connections   1000;
        }
        
        http {
          resolver 127.0.0.11;
        
          server {
            listen             3100;
        
            location = / {
              return 200 'OK';
              auth_basic off;
            }
        
            location = /api/prom/push {
              proxy_pass       http://write:3100\$$request_uri;
            }
        
            location = /api/prom/tail {
              proxy_pass       http://read:3100\$$request_uri;
              proxy_set_header Upgrade \$$http_upgrade;
              proxy_set_header Connection "upgrade";
            }
        
            location ~ /api/prom/.* {
              proxy_pass       http://read:3100\$$request_uri;
            }
        
            location = /loki/api/v1/push {
              proxy_pass       http://write:3100\$$request_uri;
            }
        
            location = /loki/api/v1/tail {
              proxy_pass       http://read:3100\$$request_uri;
              proxy_set_header Upgrade \$$http_upgrade;
              proxy_set_header Connection "upgrade";
            }
        
            location ~ /loki/api/.* {
              proxy_pass       http://read:3100\$$request_uri;
            }
          }
        }
        EOF
        /docker-entrypoint.sh nginx -g "daemon off;"
    ports:
      - 3100:3100
    healthcheck:
      test: [ "CMD", "service", "nginx", "status" ]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - your-network
```
### Grafana service to visualize logs
```yaml
services:
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - 3000:3000
    environment:
      - GF_PATHS_PROVISIONING=/etc/grafana/provisioning
      - GF_AUTH_ANONYMOUS_ENABLED=true
      - GF_AUTH_ANONYMOUS_ORG_ROLE=Admin
    entrypoint:
      - sh
      - -euc
      - |
        /run.sh
    volumes:
        - ./grafana/datasource.yml:/etc/grafana/provisioning/datasources/datasource.yml
    networks:
      - your-network
```
### Data source configuration for grafana
```yaml
apiVersion: 1

deleteDatasources:
  - name: Loki

datasources:
  - name: Loki
    type: loki
    uid: loki
    access: proxy
    orgId: 1
    editable: true
    url: http://gateway:3100
    jsonData:
      httpHeaderName1: "X-Scope-OrgID"
      derivedFields:
        - datasourceUid: tempo
          matcherRegex: "\\[.+,(.+),.+\\]"
          name: TraceID
          url: '$${__value.raw}'
    secureJsonData:
      httpHeaderValue1: "tenant1"
```
* Alloy configuration file is in alloy folder
* Loki configuration file is in loki folder
* Goto - grafana dashboard - http://localhost:3000
* Select Explore and select Loki as datasource and query logs.
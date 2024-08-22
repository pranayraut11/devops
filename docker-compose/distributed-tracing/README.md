Distributed tracing with opentelemetry and tempo

This example demonstrates how to use opentelemetry to instrument a simple web application and send traces to tempo.

Dependencies:
Enable actuator in the spring boot application
```
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```
Add opentelemetry dependencies(Here we are using opentelemetry-javaagent)
```
<dependency>
	<groupId>io.opentelemetry.javaagent</groupId>
	<artifactId>opentelemetry-javaagent</artifactId>
	<version>1.33.5</version>
	<scope>runtime</scope>
</dependency>
```

docker compose for tempo server
```
  tempo:
    image: grafana/tempo:2.4.2
    container_name: tempo
    command: -config.file /etc/tempo-config.yml
    ports:
      - "3110:3100"
      - "4317:4317"
    volumes:
      - ./tempo/tempo.yml:/etc/tempo-config.yml
    networks:
      - your-network
```
tempo configuration file tempo.yml
```
server:
  http_listen_port: 3100
  
distributor:
  receivers:
    otlp:
      protocols:
        grpc:
        http:

ingester:
  trace_idle_period: 10s
  max_block_bytes: 1_000_000
  max_block_duration: 5m

compactor:
  compaction:
    compaction_window: 1h
    max_compaction_objects: 1000000
    block_retention: 1h
    compacted_block_retention: 10m

storage:
  trace:
    backend: local
    local:
      path: /tmp/tempo/blocks
    pool:
      max_workers: 100
      queue_depth: 10000
```

docker compose for web application
```
  web:
    image: openjdk:11
    container_name: web
    ports:
      - "8080:8080"
    volumes:
      - ./web/target/web-0.0.1-SNAPSHOT.jar:/app.jar
    networks:
      - your-network
    environment:
      JAVA_TOOL_OPTIONS: "-javaagent:/app/libs/opentelemetry-javaagent-1.33.5.jar"
      OTEL_EXPORTER_OTLP_ENDPOINT: http://tempo:4317
      OTEL_METRICS_EXPORTER: none
      OTEL_SERVICE_NAME: service-name
    
```

Add the following properties in application.yml
```
management:
  endpoints:
    web:
      exposure:
        include: "*"
  health:
    readiness-state:
      enabled: true
    liveness-state:
      enabled: true
    endpoint:
      shutdown:
        enabled: true
      health:
        probes:
          enabled: true

logging:
  pattern:
    level: "%5p [${spring.application.name},%X{trace_id},%X{span_id}]"
```
Datasource configuration for grafana
```
apiVersion: 1

deleteDatasources:
  - name: Tempo

datasources:
  - name: Tempo
    type: tempo
    uid: tempo
    access: proxy
    orgId: 1
    editable: true
    url: http://tempo:3100
    basicAuth: false
    isDefault: false
    version: 1
    jsonData:
      httpMethod: GET
      serviceMap:
        datasourceUid: 'prometheus'
```
Go to grafana dashboard - http://localhost:3000
Select Explore and select Tempo as datasource and query traces.
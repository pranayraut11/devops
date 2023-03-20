### This deployement script deployes two applications in one pod.
* Spring boot application
* filebeat application

### What deployment script does
* Spring boot applicaiton genereates some logs in Spring.log file inside "logs" folder.
To set log file path set env variable "LOGGING_FILE_PATH" in sample-deployment.yml file
* filebeat push that logs to elasticsearch.
* filebeat uses filebeat config file in which we have to set log file location and elasticsearch url

### Deployment steps
* Create config map object
    ```
    kubectl create configmap elk-filebeat-cfgmap --from-file ./filebeat.yml
    ```
* Create deployment
```
kubectl apply -f example-deployment.yml
```    
* Check pods status
```
kubectl get pods
```
Output should be 
```
NAME                                        READY   STATUS              RESTARTS   AGE
cart-deployment-595bf775f9-dwcfk            2/2     ContainerCreating   0          44s
elasticsearch-deployment-6c97c49c7b-2jjhb   1/1     Running             0          20h
kibana-deployment-644d9c5f4d-r4sm5          1/1     Running             0          20h
```

* Now goto kibana UI
And follow the steps to search logs
    
    * Goto Management -> Stack Management -> Data -> Index Management <br>
    You can find filebeat index . eg.
     "filebeat-7.16.2-2023.03.20-000001"
    * Goto Management -> Stack Management -> Kibana -> Index Patterns <br>
    Click on "Create index pattern" button and fill "Name" field "filebeat*" and "Timestamp field" field "@timestamp" and hit Create index pattern" button.
    This will create index pattern.
    * Goto Menu -> Discover <br>
    Now you should be able to see you application logs 

### This is simple example for helm chart which will deploy simple web-app(Spring boot application) on kubernetes cluster.
Clone the project 
Go to directory devops/helm/example
```
cd devops/helm/example
```
To install web application on kubernetes hit following command
```
 helm install dev example/
```
Here "dev" is any random name.

#### Check application pod status
```
kubectl get pods
```
Check application logs
```
kubectl logs "<pod_name>"
eg. kubectl logs webapp-example-5c586b9f4f-8rn7l
```

Get cluster IP
```
minikube ip
```

Url would be 
```
http://<cluster_ip>:32762/home
```

Check web app API response
```
curl http://<cluster_ip>:32762/home
```
Response should be "home"

### Uninstall deployed web application
```
helm uninstall dev
```


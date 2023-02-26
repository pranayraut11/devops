### Enable ingress controller in minikube
```
minikube addons enable ingress
```
#### Check status
```
kubectl get pods -n ingress-nginx
```
The output is similar to
```
NAME                                        READY   STATUS      RESTARTS    AGE
ingress-nginx-admission-create-g9g49        0/1     Completed   0          11m
ingress-nginx-admission-patch-rqp78         0/1     Completed   1          11m
ingress-nginx-controller-59b45fb494-26npt   1/1     Running     0          11m
```

### Run example
```
kubectl apply -f deployment.yaml
```
Check status 
```
kubectl get deployments
kubectl get pods
kubectl get replicaset
```

Expose the deployment 
```
kubectl expose deployment ingress-demo --type=NodePort --port=8080
```
#### Verify the service
```
kubectl get service
```
### Access the application via the node-ip and the node port
```
kubectl get nodes -o wide
```
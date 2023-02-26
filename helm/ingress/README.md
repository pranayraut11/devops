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
> Note : If you are running minikube/kind cluster on wsl(ubuntu) then you will have to use port forwarding.
```
kubectl port-forward service/ingress-demo 31866:8080
```
> Note : kubectl port-forward does not return.

To access application on browser 
```
http://localhost:31866
```

### Now apply ingress configuration
```
kubectl apply -f ingress.yaml
```
> Note : After creating ingress for service, port forward not is required.You can access application directly from browser.

#### Add "hello-worldapp.com" to hosts file 
```
path to hosts file : "C:\Windows\System32\drivers\etc"
Eg : 127.0.0.1 hello-worldapp.com
```
Check browser
```
http://hello-worldapp.com/v1
```

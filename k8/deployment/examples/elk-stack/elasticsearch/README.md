## Steps to install elasticsearch
```
kubectl apply -f elasticsearch-deployment.yml
``` 

We used "elasticsearch-deployment.yml" file to create elasticsearch pod and deployment objects in kubernetes cluster.

### To check pod status 
```
kubectl get pods
```
### To check pod specific events
```
kubectl describe pod <pod_name>
```

##  Expose elasticsearch deployment as service(Cluster IP) to access pod by "elasticsearch" name.
```
kubectl apply -f elasticsearch-service.yml
```

### Check elasticsearch service
```
kubectl get svc
```
## We have successfully installed elasticsearch
But we can not access it outside the kubernetes cluster.
For elk stack setup we just need to access elasticsearch within the cluster.
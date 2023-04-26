## Steps to install kibana
```
kubectl apply -f kibana-deployment.yml
``` 

We used "kibana-deployment.yml" file to create kibana pod and deployment objects in kubernetes cluster.

### To check pod status 
```
kubectl get pods
```
### To check pod specific events
```
kubectl describe pod <pod_name>
```

##  Expose kibana deployment as service(Cluster IP) to access pod by "kibana" name.
```
kubectl apply -f kibana-service.yml
```

### Check kibana service
```
kubectl get svc
```
## We have successfully installed kibana
But we can not access it outside the kubernetes cluster.
As kibana is UI for elk stack. We need to access it through browser.
### To access kibana from browser 
We will need to create ingress configuration for kibana.

### Create ingress for kibana
```
kubectl apply -f kibana-ingress.yml
```
### Check ingress 
```
kubectl get ingress
```

### To access Kibana UI on browser
```
http://kibana
```
> **Note** <br>
To access kibana from browser
Make entry in hosts file 
"127.0.0.1 kibana"

> **Note** <br>
  Before creating ingress config for kibana.Check ingress is enabled or not for your cluster. 

To Check ingress installation.
```
kubectl get pods --namespace ingress-nginx
```
Output should be similar to
```
NAME                                        READY   STATUS      RESTARTS    AGE
ingress-nginx-admission-create-g9g49        0/1     Completed   0          11m
ingress-nginx-admission-patch-rqp78         0/1     Completed   1          11m
ingress-nginx-controller-59b45fb494-26npt   1/1     Running     0          11m
```

If output is not similar to above .
Then follow the steps to enable ingress.
[Ingress installation](https://github.com/pranayraut11/devops/tree/master/k8 )

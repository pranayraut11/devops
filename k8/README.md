## Install kubernetes cluster(Minikube) on linux

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### Start cluster

```
minikube start
```
Verify cluster
```
minikube kubectl -- get pods -A
```
Make kubectl command short
```
alias kubectl="minikube kubectl --"
```
Now you can use kubectl command directly without appending "minikube"
```
kubectl get pods
```
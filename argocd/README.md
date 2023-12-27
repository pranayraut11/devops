## Setup Argocd for application deployment


#### Create Namespace
```
kubectl create namespace argocd
```

#### Install argocd using helm chart
```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

#### Check argocd installation status
```
watch kubectl get pods -n argocd
```
#### Get password for login to Argocd application (Username : admin)
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
#### Forword port to access Application from browser
```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### Deploy application using Argocd
* Login to Argocd application 
* Click on create application
* Provide all required details

We can use helm chart to deploy application .

* Application Name : should be match to your chart.yml name field 
* Project Name : should be "default"
* Sync policy : Manual
* Repository URL : provide git repo url from which helm chart will be refered
* Path : provide helm chart directory path from your repo.
* Cluster URL : https://kubernetes.default.svc
* Namespace : default

#### Hit Create button
That's it 
<br>you can see your application On Application page

We will install helm in this tutorial
### Prerequisite
* Kubernetes cluster installed (https://github.com/pranayraut11/devops/blob/master/k8/README.md)

### Helm installation

```
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
```
```
sudo apt-get install apt-transport-https --yes
```
```
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
```
```
sudo apt-get update
```
```
sudo apt-get install helm
```

### Basic commands 

List helm repository
```
helm repo list
```
Add repository to list
```
helm repo add "repo_name" url
eg. helm repo add bitnami https://charts.bitnami.com/bitnami
```
Search to repository
```
helm search repo mongo
```
Install mysql(Just an example) using helm
```
helm install mysql bitnami/mysql
```

To see helm notes
```
helm status mysql
```
Uninstall mysql
```
helm uninstall mysql
```
Upgrade helm chart
```
helm upgrade mysql bitnami/mysql --values "path-to-value.yaml-file"
```

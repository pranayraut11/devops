## AWS EKS Cluster Setup
### Prerequisites
- AWS account
- AWS CLI installed
- kubectl installed
- eksctl installed

### Setup AWS User to connect to AWS account
* Goto AWS console login with root account and create a new user with programmatic access and attach AdministratorAccess policy to the user.
* To attach AdministratorAccess policy to the user you will have to create a new group and attach the policy to the group.
* After creating user group attach the user to the group.
* Create secret key and access key for the user and save it in your local machine.
* Note down your region and account id.
### Configure AWS CLI with the secret key and access key.
```bash
aws configure
```
This will prompt you to enter the secret key, access key, region and output format.
### Cross-check the configuration
```bash
aws iam get-user
```

You have successfully connected to your AWS account using AWS CLI.
### Create EKS Cluster using eksctl
* Create a file named eks-cluster.yaml
```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: cluster-name
  region: AWS_REGION
  tags:
    project: eks-cluster-tag

nodeGroups:
  - name: NODE_GROUP_NAME
    instanceType: INSTANCE_TYPE
    desiredCapacity: NUMBER_OF_NODES
```
* Replace the placeholders with your values.
* For INSTANCE_TYPE refer to the [AWS EC2 instance types](https://aws.amazon.com/ec2/instance-types/)
* Create the cluster using the following command
```bash
eksctl create cluster -f eks-cluster.yaml
```
* This will create a new EKS cluster with number of nodes specified in the yaml file.
* To check the status of the cluster
```bash
kubectl config get-contexts
```
Your cluster is ready to use.

* You can deploy your applications to the cluster using kubectl or helm.
* But applications deployed using kubectl will not be highly available to outside world.
* To make the applications highly available you will have to create a load balancer and attach it to the service.

### Create a Load Balancer

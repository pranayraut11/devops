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
* Note down your region and account id(ARN).
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
* To make the applications available you will have to create a load balancer and attach it to the service.

### Make Subnet discoverable by Adding tags to VPC
* Goto AWS console and search for VPC.
* Select the VPC created by eksctl.
* Add the following tags to the private subnets.
```yaml
Key: kubernetes.io/cluster/cluster-name
Value: shared
```
* This will allow the cluster to use the VPC.
### Create Service account for load balancer controller
### What is service account?
#### A service account is used to access the AWS resources from the EKS cluster.

### Create IAM policy for the service account
Download the IAM policy from the following link
```bash
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.1/docs/install/iam_policy.json
```
Create IAM policy using the following command
```bash
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json
```
Check the policy on AWS console.
Go to AWS console and search for IAM->Policies->AWSLoadBalancerControllerIAMPolicy

### Create IAM OIDC provider
```bash
eksctl utils associate-iam-oidc-provider \
    --region AWS_REGION \
    --cluster cluster-name \
    --approve
```
### Create IAM role for the service account
```bash
eksctl create iamserviceaccount \
--cluster=eks-cluster \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::ARN_NUMBER:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--approve
```
Use the ARN(Account ID) which is created in the previous step.

#### Check the service account 
```bash
kubectl get sa -n kube-system
```

AWS load balancer controller requires a cert manager to create the certificate for the load balancer.
### Install cert manager
```bash
kubectl apply \
    --validate=false \
    -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml
```
Check the status of the cert manager
```bash
kubectl get pods -n cert-manager 
```
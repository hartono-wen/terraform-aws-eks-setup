# Terraform AWS EKS Setup
This is a repository for Terraform configuration example to setup a new AWS EKS cluster from scratch.
This will provisioned the following resources:
* VPC
* Private and public subnets, and the related route tables for each availability zones
* Internet NAT gateways for the private subnets
* Elastic IP addresses to attach to each internet NAT gateways
* Security groups for the VPC
* EKS cluster with one node group with one EC2 instance

## Room for Improvements
* This repository still has so many room of improvements. There are things that I do not implement for the sake of simplicity. So, if you think of using this repository in PROD environment, please take a look at the code, weed out the not-so-best practices and make the necessary improvement.
* I don't like including the `eks` module into one module `eks-from-scratch` as shown in this repository. But, for the sake of simplicity of showing how this repository can be used to provision an AWS EKS cluster from an empty AWS console, I chose to still do this.
* Messy `providers` declaration structure. This repository uses multiple `providers` such as `aws` provider, `helm` provider, and `kubernetes` provider, and the arrangement of the `providers` is not the best. This is definitely something that can be improved.
* I tried following <a href="https://cloud.google.com/docs/terraform/best-practices-for-terraform">the best-practice code structure as recommended by Google</a>.
* I put the number ordering on the prefix of the directory name to help people understand the order of the way the resources are created. It also helps me to see the ordering and I don't have to rely everytime on `terraform graph` to see which depends on which.
* I commited the `var-files` just to show how to use this repository.
* Not using `output` effectively.
* Very minimal documentation. This can be improved later.

## Requirements
* You must have the AWS credentials that are able to create the resources stated above
* You must have Terraform installed and configured on your local machine
* `kubectl`, to later test the Kubernetes cluster
* `helm`, to install the AWS Load Balancer Controller for the EKS ingress controller
* `aws cli` to enable the provisioner to authenticate against the created AWS EKS cluster.
* Don't forget to configure the backend to your liking. Currently, it's configured to:
    * AWS S3 bucket `hartono-terraform-backend-non-prod` for non-PROD environments (`staging` and `UAT`)
    * AWS S3 bucket `hartono-terraform-backend-prod` for PROD environments
    * You won't be able to use the buckets name anymore because those buckets are already created by me

## Authentication Method
To use this repository, once you get the AWS credentials, you can either:
* Configure the AWS CLI
* Or, specify the AWS-specific environment variables in the same session with the Terraform script execution environment. The environment variables required are:
```
export AWS_ACCESS_KEY_ID=AKxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=J87xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
export AWS_REGION=ap-southeast-1
```

## How to Use
To use this repository, we can just go into the directory of the environment that we would like to deploy to.

```sh
cd ./environments/${your-targeted-environment};
```

For example, let's say we want to work in `staging` environment:
```sh
cd ./environments/01.staging;
```

And then, we can initialize the Terraform repository by running this command:
```sh
terraform init;
```

To create the Terraform plan for this repository, we can run this command:
```sh
terraform plan -out staging.tfplan -var-file=staging.tfvars;
```

And, finally, to apply the Terraform plan, we can run this command:
```sh
terraform apply staging.tfplan;
```

Once the plan is successfully applied, we can use a simple application such as 2048 game to test the cluster.
To setup the 2048 game, we can just run this command:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/examples/2048/2048_full.yaml
```

Once done, check whether the ingress has been created by running:
```
kubectl -n game-2048 get ingress
```
You should see this kind of output:
```
$ kubectl -n game-2048 get ingress
NAMESPACE   NAME           CLASS   HOSTS   ADDRESS                                                                       PORTS   AGE
game-2048   ingress-2048   alb     *       k8s-game2048-ingress2-2e76e9e9cb-322536612.ap-southeast-1.elb.amazonaws.com   80      6m5s
```
Please note that the name of the ingress might be different because it was randomly set by AWS.
If you can see the ingress, you can now access the 2048 game by going to that address (in the above example, it is: `k8s-game2048-ingress2-2e76e9e9cb-322536612.ap-southeast-1.elb.amazonaws.com`).

Note: There will be a time until the AWS Application Load Balancer is finished provisioned by the creation of the ingress specified in the 2048 game YAML configuration. If you have tried hitting the address before the AWS Application Load Balancer is fully provisioned, you might experience some error. Please keep hitting the same address for a while. You can also check in the AWS console whether the AWS Application Load Balancer is already completely provisioned

## Destroy
Once you have done with the experiment, you can run these commands to terminate all the provisioned resources:
### Delete the 2048 game Kubernetes objects:
```
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/examples/2048/2048_full.yaml
```
### Destroy the Terraform-provisioned resources;
```
terraform destroy;
```
After running the `terraform destroy` command, Terraform will check the state and will ask you to confirm whether you want to destroy the resources. Type `yes` to destroy the resources.

## Code Format
This repository is formatted using the default Terraform code formatter.

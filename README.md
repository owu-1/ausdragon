Attempt to make the cheapest Kubernetes cluster with GPU nodes on AWS. Kubernetes is self-managed and everything is running on spot EC2 instances.

The instruction below assume you have AWS CLI with a profile setup, terraform, and kops installed.

Create a new file in cloud-computing/variables.sh based on cloud-computing/variables.example.sh. You can ignore kops_aws_profile for now since the IAM user will be created with terraform first.

Ensure that the terraform_state_bucket exists in the specified AWS region.

Enter the terraform environment by running "source cloud-computing/terraform/env.sh".

Initialise terraform by running cloud-computing/terraform/init.sh.

Terraform will setup the necessary resources for kops. To provision the resources run "terraform apply".

Create an access key for kops IAM user. Setup a AWS CLI profile for it and enter the profile into cloud-computing/variables.sh as kops_aws_profile.

Enter the kops environment by running "source cloud-computing/kops/env.sh".

Create the cluster configuration by running cloud-computing/kops/create-cluster.sh.

Deploy the cluster resources by running "kops update cluster --name $domain_name --yes --admin"

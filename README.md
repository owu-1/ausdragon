Attempt to make the cheapest Kubernetes cluster with GPU nodes on AWS. Kubernetes is self-managed and everything is running on spot EC2 instances.

The instructions below assume you have AWS CLI with a profile setup ([AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions)) ([SSO profile](https://docs.aws.amazon.com/cli/latest/userguide/sso-configure-profile-token.html)) ([IAM profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html#cli-authentication-user-configure.title)), [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform), [kOps](https://kops.sigs.k8s.io/getting_started/install/).

Create a new file in cloud-computing/variables.sh based on cloud-computing/variables.example.sh. You can ignore kops_aws_profile for now since the IAM user will be created with terraform first. Control plane nodes can work on 1 vCPU.

Ensure that the terraform_state_bucket exists in the specified AWS region.

Enter the terraform environment by running "source cloud-computing/terraform/env.sh".

Initialise terraform by running cloud-computing/terraform/init.sh.

Terraform will setup the necessary resources for kops. To provision the resources run "terraform apply".

Create an access key for kops IAM user. Setup a AWS CLI profile for it and enter the profile into cloud-computing/variables.sh as kops_aws_profile.

Enter the kops environment by running "source cloud-computing/kops/env.sh".

Create the cluster configuration by running cloud-computing/kops/create-cluster.sh.

Deploy the cluster resources by running "kops update cluster --name $domain_name --yes --admin"

Once the cluster is healthy, under cloud-computing/kserve run download_yamls.sh, then patch_yamls.sh, then install.sh to install Kserve.

Example cloud-computing/variables.sh file

```sh
#!/bin/bash

# AWS options to create the infrastructure with
terraform_aws_profile=root
kops_aws_profile=kops
aws_region=ap-northeast-2
aws_avalibility_region=ap-northeast-2a

# S3 bucket for terraform state
terraform_state_bucket=terraform-state-abc123

# S3 buckets for kubernetes cluster
state_store_bucket=state-store-abc123
oidc_store_bucket=oidc-store-abc123

# Domain name to be used for kubernetes cluster
domain_name=example.com

# Control plane machine settings
control_plane_image=099720109477/ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-20240228
control_plane_machine_type=m7g.medium
control_plane_volume_size=20

# CPU node machine settings
cpu_node_image=099720109477/ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240228
cpu_node_machine_type=t3.micro
cpu_node_volume_size=20

# GPU node machine settings
gpu_node_image=099720109477/ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-20240228
gpu_node_machine_type=g5g.xlarge
gpu_node_volume_size=20
```

You can edit cloud-computing/kops/cluster.tmpl.yml to adjust scaling min/max and change instances to on-demand for more stability. Also if you want T instances to run in standard mode, uncomment "cpuCredits: standard" for your instance group.

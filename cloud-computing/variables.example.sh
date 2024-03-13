#!/bin/bash

# AWS options to create the infrastructure with
terraform_aws_profile=root
kops_aws_profile=kops
# todo: name aws region variables better
aws_region=ap-northeast-2
aws_avalibility_region=ap-northeast-2a
identity_provider_aws_region=ap-northeast-2

# Domain names
base_domain_name=example.com
cluster_domain_name="kubernetes.$base_domain_name"

# Subdomain used for deployKF
deploykf_domain_name="deploykf.$cluster_domain_name"

# Admin email
admin_email="admin@$base_domain_name"
admin_email_routing_destination=user@example.net

# S3 bucket for terraform state
terraform_state_bucket=terraform-state-abc123

# S3 buckets for kubernetes cluster
state_store_bucket=state-store-abc123
oidc_store_bucket=oidc-store-abc123

# S3 bucket for kubeflow
kubeflow_pipelines_bucket=kubeflow-pipelines-abc123

# Ports used for deployKF
# todo: explain nodeport range
deploykf_http_port=30000 # ingress does not expose this port
deploykf_https_port=30001

# Control plane machine settings
control_plane_image=099720109477/ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-20240228
control_plane_machine_type=m7g.medium
control_plane_volume_size=20

# CPU node machine settings
cpu_node_image=099720109477/ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240228
cpu_node_machine_type=c5a.xlarge
cpu_node_volume_size=30

# GPU node machine settings
gpu_node_image=099720109477/ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-20240228
gpu_node_machine_type=g5g.xlarge
gpu_node_volume_size=20

# Cloudflare
# todo: might be giving unnecessary permissions. double check
# Permissions
# Account | Email Routing Addresses | Edit
# Account | Email Routing Addresses | Read
# Zone    | Email Routing Rules     | Edit
# Zone    | Email Routing Rules     | Read
# Zone    | Zone Settings           | Edit
# Zone    | Zone Settings           | Read
# Zone    | Zone                    | Edit
# Zone    | Zone                    | Read
# Zone    | DNS                     | Edit
# Zone    | DNS                     | Read
# Account Resources
# Include | All accounts
# Zone Resources
# Include | All zones from an account | account-name
cloudflare_account_id=abcdef123
cloudflare_api_token=abcdef123

# Cognito
# todo: automatically fill this in after terraform apply
cognito_user_pool_id=ap-northeast-2_abcdef123
cognito_client_id=abcdef123
cognito_client_secret=abcdef123
cognito_domain_name="cognito.$base_domain_name"

#!/bin/bash
PS1="(terraform) $PS1"
source ../variables.sh

export AWS_REGION="$identity_provider_aws_region"
export AWS_PROFILE="$terraform_aws_profile"
export CLOUDFLARE_API_TOKEN="$cloudflare_api_token"
export TF_VAR_aws_region="$aws_region"
export TF_VAR_identity_provider_aws_region="$identity_provider_aws_region"
export TF_VAR_terraform_state_bucket="$terraform_state_bucket"
export TF_VAR_state_store_bucket="$state_store_bucket"
export TF_VAR_oidc_store_bucket="$oidc_store_bucket"
export TF_VAR_base_domain_name="$base_domain_name"
export TF_VAR_cluster_domain_name="$cluster_domain_name"
export TF_VAR_kubeflow_pipelines_bucket="$kubeflow_pipelines_bucket"
export TF_VAR_admin_username="$admin_username"
export TF_VAR_admin_email="$admin_email"
export TF_VAR_cognito_domain_name="$cognito_domain_name"
export TF_VAR_cloudflare_account_id="$cloudflare_account_id"
export TF_VAR_admin_email_routing_destination="$admin_email_routing_destination"
export TF_VAR_deploykf_domain_name="$deploykf_domain_name"
export TF_VAR_deploykf_https_port="$deploykf_https_port"

export terraform_state_bucket="$terraform_state_bucket"

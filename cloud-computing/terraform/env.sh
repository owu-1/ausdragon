#!/bin/bash
PS1="(terraform) $PS1"
source ../variables.sh

export AWS_REGION="$aws_region"
export AWS_PROFILE="$terraform_aws_profile"
export TF_VAR_aws_region="$aws_region"
export TF_VAR_terraform_state_bucket="$terraform_state_bucket"
export TF_VAR_state_store_bucket="$state_store_bucket"
export TF_VAR_oidc_store_bucket="$oidc_store_bucket"
export TF_VAR_domain_name="$domain_name"
export TF_VAR_kubeflow_pipelines_bucket="$kubeflow_pipelines_bucket"

export terraform_state_bucket="$terraform_state_bucket"

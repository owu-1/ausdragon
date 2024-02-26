. ..\variables.ps1

# Variables for terraform
$Env:AWS_REGION=$aws_region
$Env:AWS_PROFILE=$terraform_aws_profile
$Env:TF_VAR_aws_region=$aws_region
$Env:TF_VAR_terraform_state_bucket=$terraform_state_bucket
$Env:TF_VAR_state_store_bucket=$state_store_bucket
$Env:TF_VAR_oidc_store_bucket=$oidc_store_bucket
$ENV:TF_VAR_domain_name=$domain_name

. ..\variables.ps1

# Environment variables to run kops
$Env:AWS_REGION=$aws_region
$Env:AWS_PROFILE=$kops_aws_profile
$Env:KOPS_STATE_STORE=$state_store_bucket

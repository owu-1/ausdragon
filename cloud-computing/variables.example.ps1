# The AWS options to create the infrastructure with
$kops_aws_profile="insert-aws-profile-name"
$terraform_aws_profile="insert-aws-profile-name"
$aws_region="insert-aws-region-name"
$aws_avalibility_region="insert-avalibility-region-name"
# S3 bucket for terraform state
$terraform_state_bucket="insert-terraform-state-bucket-name"
# S3 buckets for kubernetes cluster
$state_store_bucket="insert-state-store-bucket-name"
$oidc_store_bucket="insert-oidc-store-bucket-name"
# Domain name to be used for kubernetes cluster
$domain_name="insert-domain-name"
# Master machine settings
$master_image="insert-master-image"
$master_machine_type="insert-master-machine-type"
$master_volume_size="insert-control-plane-volume-size"
# Node machine settings
$node_image="insert-node-image"
$node_machine_type="insert-node-machine-type"
$node_volume_size="insert-node-volume-size"

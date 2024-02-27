#!/bin/bash
PS1="(kops) $PS1"
source ../variables.sh

export AWS_REGION="$aws_region"
export AWS_PROFILE="$kops_aws_profile"
export KOPS_STATE_STORE="s3://$state_store_bucket"

export domain_name="$domain_name"
export state_store_bucket="$state_store_bucket"
export oidc_store_bucket="$oidc_store_bucket"
export aws_avalibility_region="$aws_avalibility_region"

export master_image="$master_image"
export master_machine_type="$master_machine_type"
export master_volume_size="$master_volume_size"

export node_image="$node_image"
export node_machine_type="$node_machine_type"
export node_volume_size="$node_volume_size"

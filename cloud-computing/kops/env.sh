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

export control_plane_image="$control_plane_image"
export control_plane_machine_type="$control_plane_machine_type"
export control_plane_volume_size="$control_plane_volume_size"

export cpu_node_image="$cpu_node_image"
export cpu_node_machine_type="$cpu_node_machine_type"
export cpu_node_volume_size="$cpu_node_volume_size"

export gpu_node_image="$gpu_node_image"
export gpu_node_machine_type="$gpu_node_machine_type"
export gpu_node_volume_size="$gpu_node_volume_size"

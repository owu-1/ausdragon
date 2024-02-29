#!/bin/bash

# AWS options to create the infrastructure with
terraform_aws_profile=insert-aws-profile-name
kops_aws_profile=insert-aws-profile-name
aws_region=insert-aws-region-name
aws_avalibility_region=insert-avalibility-region-name

# S3 bucket for terraform state
terraform_state_bucket=insert-terraform-state-bucket-name

# S3 buckets for kubernetes cluster
state_store_bucket=insert-state-store-bucket-name
oidc_store_bucket=insert-oidc-store-bucket-name

# Domain name to be used for kubernetes cluster
domain_name=insert-domain-name

# Control plane machine settings
control_plane_image=insert-control-plane-image
control_plane_machine_type=insert-control-plane-machine-type
control_plane_volume_size=insert-control-plane-volume-size

# CPU node machine settings
cpu_node_image=insert-cpu-node-image
cpu_node_machine_type=insert-cpu-node-machine-type
cpu_node_volume_size=insert-cpu-node-volume-size

# GPU node machine settings
gpu_node_image=insert-gpu-node-image
gpu_node_machine_type=insert-gpu-node-machine-type
gpu_node_volume_size=insert-gpu-node-volume-size

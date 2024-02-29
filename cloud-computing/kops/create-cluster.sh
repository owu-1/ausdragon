#!/bin/bash
kops toolbox template --name "$domain_name" \
    --template cluster.tmpl.yml \
    --set-string "domain_name=$domain_name" \
    --set-string "state_store_bucket=$state_store_bucket" \
    --set-string "oidc_store_bucket=$oidc_store_bucket" \
    --set-string "aws_avalibility_region=$aws_avalibility_region" \
    --set-string "control_plane_image=$control_plane_image" \
    --set-string "control_plane_machine_type=$control_plane_machine_type" \
    --set-string "control_plane_volume_size=$control_plane_volume_size" \
    --set-string "cpu_node_image=$cpu_node_image" \
    --set-string "cpu_node_machine_type=$cpu_node_machine_type" \
    --set-string "cpu_node_volume_size=$cpu_node_volume_size" \
    --set-string "gpu_node_image=$gpu_node_image" \
    --set-string "gpu_node_machine_type=$gpu_node_machine_type" \
    --set-string "gpu_node_volume_size=$gpu_node_volume_size" > cluster.yml

kops create -f cluster.yml

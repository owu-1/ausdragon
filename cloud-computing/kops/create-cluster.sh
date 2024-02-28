#!/bin/bash
kops toolbox template --name "$domain_name" \
    --template cluster.tmpl.yml \
    --set-string "domain_name=$domain_name" \
    --set-string "state_store_bucket=$state_store_bucket" \
    --set-string "oidc_store_bucket=$oidc_store_bucket" \
    --set-string "aws_avalibility_region=$aws_avalibility_region" \
    --set-string "master_image=$master_image" \
    --set-string "master_machine_type=$master_machine_type" \
    --set-string "master_volume_size=$master_volume_size" \
    --set-string "node_image=$node_image" \
    --set-string "node_machine_type=$node_machine_type" \
    --set-string "node_volume_size=$node_volume_size" \
    --set-string "gpu_node_image=$gpu_node_image" \
    --set-string "gpu_node_machine_type=$gpu_node_machine_type" \
    --set-string "gpu_node_volume_size=$gpu_node_volume_size" > cluster.yml

kops create -f cluster.yml

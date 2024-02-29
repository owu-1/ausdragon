#!/bin/bash
kops create cluster \
    --name="$domain_name" \
    --cloud=aws \
    --zones="$aws_avalibility_region" \
    --discovery-store="s3://$oidc_store_bucket/$domain_name/discovery" \
    --control-plane-volume-size="$control_plane_volume_size" \
    --node-volume-size="$node_volume_size" \
    --dry-run -o yaml > cluster.yml

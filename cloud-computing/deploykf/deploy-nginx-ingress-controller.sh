#!/bin/bash
source ../variables.sh

export deploykf_http_port="$deploykf_http_port"
export deploykf_https_port="$deploykf_https_port"

# hardcoded document_index
curl -SsL https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/baremetal/deploy.yaml |
yq 'select(document_index == 12).spec.ports[0].nodePort = env(deploykf_http_port) |
    select(document_index == 12).spec.ports[1].nodePort = env(deploykf_https_port)' > nginx-ingress-controller.yaml

kubectl apply -f nginx-ingress-controller.yaml

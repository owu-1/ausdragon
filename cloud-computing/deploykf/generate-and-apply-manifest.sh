#!/bin/bash
source ../variables.sh

export aws_region="$aws_region"
export deploykf_domain_name="$deploykf_domain_name"
export deploykf_http_port="$deploykf_http_port"
export deploykf_https_port="$deploykf_https_port"
export kubeflow_pipelines_bucket="$kubeflow_pipelines_bucket"

yq '.metadata.annotations."nginx.ingress.kubernetes.io/proxy-ssl-name" = strenv(deploykf_domain_name) |
    .metadata.annotations."external-dns.alpha.kubernetes.io/hostname" = "*." + strenv(deploykf_domain_name) + ", " + strenv(deploykf_domain_name) |
    .spec.rules[0].host = strenv(deploykf_domain_name) |
    .spec.rules[0].http.paths[0].backend.service.port.number = env(deploykf_https_port) |
    .spec.rules[1].host = "*." + strenv(deploykf_domain_name) |
    .spec.rules[1].http.paths[0].backend.service.port.number = env(deploykf_https_port)' nginx-ingress.example.yaml > nginx-ingress.yaml

yq '.deploykf_core.deploykf_istio_gateway.gateway.hostname = strenv(deploykf_domain_name) |
    .deploykf_core.deploykf_istio_gateway.gateway.ports.http = env(deploykf_http_port) |
    .deploykf_core.deploykf_istio_gateway.gateway.ports.https = env(deploykf_https_port) |
    .deploykf_core.deploykf_istio_gateway.extraManifests = [load_str("nginx-ingress.yaml")] |
    .kubeflow_tools.pipelines.bucket.name = strenv(kubeflow_pipelines_bucket) |
    .kubeflow_tools.pipelines.bucket.region = strenv(aws_region)' values.example.yaml > values.yaml

yq '.spec.source.plugin.parameters[2].string = load_str("values.yaml")' app-of-apps.example.yaml > app-of-apps.yaml

kubectl apply --filename ./app-of-apps.yaml --namespace "argocd"

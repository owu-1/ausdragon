#!/bin/bash

# Store yamls in directory
mkdir ./yamls
cd ./yamls

# Download YAMLs
# todo: verify signatures
# Knative Serving
curl -sSL -o serving-crds.yaml https://github.com/knative/serving/releases/download/knative-v1.13.1/serving-crds.yaml
curl -sSL -o serving-core.yaml https://github.com/knative/serving/releases/download/knative-v1.13.1/serving-core.yaml
# Istio
curl -sSL -o istio.yaml https://github.com/knative/net-istio/releases/download/knative-v1.13.1/istio.yaml
curl -sSL -o net-istio.yaml https://github.com/knative/net-istio/releases/download/knative-v1.13.1/net-istio.yaml
# Cert Manager
curl -sSL -o cert-manager.yaml https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.yaml
# Kserve
curl -sSL -o kserve.yaml https://github.com/kserve/kserve/releases/download/v0.11.0/kserve.yaml
curl -sSL -o kserve-runtimes.yaml https://github.com/kserve/kserve/releases/download/v0.11.0/kserve-runtimes.yaml

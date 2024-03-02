#!/bin/bash

# Install Knative
kubectl apply -f yamls/serving-crds.yaml
kubectl apply -f yamls/serving-core.yaml

# Install Istio
kubectl apply -l knative.dev/crd-install=true -f yamls/istio.yaml
kubectl apply -f yamls/istio.yaml
kubectl apply -f yamls/net-istio.yaml

# Install Cert Manager
kubectl apply -f yamls/cert-manager.yaml

# Install KServe
kubectl apply -f yamls/kserve.yaml
kubectl apply -f yamls/kserve-runtimes.yaml

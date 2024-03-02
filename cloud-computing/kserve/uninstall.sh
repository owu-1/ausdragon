#!/bin/bash

# Install Knative
kubectl delete -f yamls/serving-crds.yaml
kubectl delete -f yamls/serving-core.yaml

# Install Istio
kubectl delete -l knative.dev/crd-install=true -f yamls/istio.yaml
kubectl delete -f yamls/istio.yaml
kubectl delete -f yamls/net-istio.yaml

# Install Cert Manager
kubectl delete -f yamls/cert-manager.yaml

# Install KServe
kubectl delete -f yamls/kserve.yaml
kubectl delete -f yamls/kserve-runtimes.yaml

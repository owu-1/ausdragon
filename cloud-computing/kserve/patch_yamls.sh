#!/bin/bash

# Patch YAMLs
patch yamls/serving-core.yaml -i serving-core.patch
patch yamls/istio.yaml -i istio.patch
patch yamls/kserve.yaml -i kserve.patch

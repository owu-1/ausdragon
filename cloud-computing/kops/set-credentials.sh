#!/bin/bash

echo kubectl oidc-login setup \
    --oidc-issuer-url="$cognito_issuer_url" \
    --oidc-client-id="$cognito_client_id" \
    --oidc-client-secret="$cognito_client_secret"

kubectl oidc-login setup \
    --oidc-issuer-url="$cognito_issuer_url" \
    --oidc-client-id="$cognito_client_id" \
    --oidc-client-secret="$cognito_client_secret"

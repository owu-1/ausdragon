#!/bin/bash
source ../variables.sh

export cognito_issuer_url="https://cognito-idp.$identity_provider_aws_region.amazonaws.com/$cognito_user_pool_id"
export cognito_client_id="$cognito_client_id"
export cognito_client_secret="$cognito_client_secret"
export deploykf_domain_name="$deploykf_domain_name"
export deploykf_https_port="$deploykf_https_port"

yq '.issuer = strenv(cognito_issuer_url) |
    .clientID = strenv(cognito_client_id) |
    .clientSecret = strenv(cognito_client_secret) |
    .redirectURI = "https://" + strenv(deploykf_domain_name) + ":" + strenv(deploykf_https_port) + "/dex/callback"' aws-cognito-config.example.yaml > aws-cognito-config.yaml

yq '.stringData.aws-cognito-config = load_str("aws-cognito-config.yaml")' aws-cognito-secret.example.yaml > aws-cognito-secret.yaml

kubectl apply -f aws-cognito-secret.yaml

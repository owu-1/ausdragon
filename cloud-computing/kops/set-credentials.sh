#!/bin/bash

read -s -p 'Enter password: ' password

# https://docs.aws.amazon.com/cognito/latest/developerguide/signing-up-users-in-your-app.html#cognito-user-pools-computing-secret-hash
secret_hash=$(echo -n "${admin_email}${cognito_client_id}" | openssl dgst -sha256 -hmac $cognito_client_secret -binary | openssl enc -base64)

# todo: check if symbols are allowed in password when using auth-parameters in this format
session=$(aws cognito-idp initiate-auth \
    --auth-flow USER_PASSWORD_AUTH \
    --client-id "$cognito_client_id" \
    --auth-parameters "USERNAME=$admin_email,PASSWORD=$password,SECRET_HASH=$secret_hash" \
    --region "$identity_provider_aws_region" \
    --endpoint-url "$cognito_issuer_url" \
    --output json | jq --raw-output '.Session')

read -p 'Enter MFA Code: ' mfa_code

tokens=$(aws cognito-idp respond-to-auth-challenge \
    --region $identity_provider_aws_region \
    --client-id $cognito_client_id \
    --challenge-name SOFTWARE_TOKEN_MFA \
    --challenge-responses USERNAME=$admin_email,SOFTWARE_TOKEN_MFA_CODE=$mfa_code,SECRET_HASH=$secret_hash \
    --session $session)

id_token=$(echo -n "$tokens" | jq --raw-output '.AuthenticationResult.IdToken')
refresh_token=$(echo -n "$tokens" | jq --raw-output '.AuthenticationResult.RefreshToken')

kubectl config set-credentials "$admin_email" \
    --auth-provider=oidc \
    --auth-provider-arg=idp-issuer-url="$cognito_issuer_url" \
    --auth-provider-arg=client-id="$cognito_client_id" \
    --auth-provider-arg=client-secret="$secret_hash" \
    --auth-provider-arg=id-token="$id_token" \
    --auth-provider-arg=refresh-token="$refresh_token"

kubectl config set-context --current --user="$admin_email"

# # todo: https://developer.okta.com/blog/2021/11/08/k8s-api-server-oidc restrict access more
# kubectl apply -f - <<EOF
# kind: ClusterRoleBinding
# apiVersion: rbac.authorization.k8s.io/v1
# metadata:
#   name: oidc-cluster-admin
# roleRef:
#   apiGroup: rbac.authorization.k8s.io
#   kind: ClusterRole
#   name: cluster-admin
# subjects:
# - kind: Group
#   name: oidc:admin
# EOF

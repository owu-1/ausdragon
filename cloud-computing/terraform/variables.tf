variable "aws_region" {
  type = string
  description = "The name of the AWS region where the resources will be created"
}

variable "identity_provider_aws_region" {
  type = string
  description = "The name of the AWS region where the identity provider is located"
}

variable "state_store_bucket" {
  type = string
  description = "The name of the state store s3 bucket"
}

variable "oidc_store_bucket" {
  type = string
  description = "The name of the oidc store s3 bucket"
}

variable "terraform_state_bucket" {
  type = string
  description = "The name of the terraform state s3 bucket"
}

variable "cluster_domain_name" {
  type = string
  description = "The domain name to use for the cluster"
}

variable "base_domain_name" {
  type = string
  description = "The base domain name"
}

# deployKF
variable "kubeflow_pipelines_bucket" {
  type = string
  description = "The name of the kubeflow pipelines bucket"
}

variable "admin_username" {
  type = string
  description = "The username of the admin in the user pool"
}

variable "admin_email" {
  type = string
  description = "The email of the admin in the user pool"
}

# variable "cognito_domain_name" {
#   type = string
#   description = "The domain name of the cognito hosted ui"
# }

variable "cloudflare_account_id" {
  type = string
  description = "The id of the cloudflare account"
}

variable "admin_email_routing_destination" {
  type = string
  description = "The email address where admin emails are routed to"
}

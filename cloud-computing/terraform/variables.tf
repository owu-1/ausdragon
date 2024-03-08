variable "aws_region" {
  type = string
  description = "The name of the AWS region where the resources will be created"
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

variable "domain_name" {
  type = string
  description = "The domain name to use for the cluster"
}

# deployKF
variable "kubeflow_pipelines_bucket" {
  type = string
  description = "The name of the kubeflow pipelines bucket"
}

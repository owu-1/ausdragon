terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

data "aws_region" "main" {
  provider = aws
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_iam_user" "rancher" {
  name = "rancher"
}

data "aws_caller_identity" "current" {}

# Use an example IAM 
# https://ranchermanager.docs.rancher.com/v2.5/how-to-guides/new-user-guides/kubernetes-clusters-in-rancher-setup/launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider/create-an-amazon-ec2-cluster#example-iam-policy
data "aws_iam_policy_document" "rancher" {
  statement {
    sid = "VisualEditor0"
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "ec2:ImportKeyPair",
      "ec2:CreateKeyPair",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteKeyPair",
      "ec2:ModifyInstanceMetadataOptions"
    ]
    resources = ["*"]
  }

  statement {
    sid = "VisualEditor1"
    actions = [
      "ec2:RunInstances"
    ]
    resources = [
      "arn:aws:ec2:${data.aws_region.main.name}::image/ami-*",
      "arn:aws:ec2:${data.aws_region.main.name}:${data.aws_caller_identity.current.account_id}:instance/*",
      "arn:aws:ec2:${data.aws_region.main.name}:${data.aws_caller_identity.current.account_id}:placement-group/*",
      "arn:aws:ec2:${data.aws_region.main.name}:${data.aws_caller_identity.current.account_id}:volume/*",
      "arn:aws:ec2:${data.aws_region.main.name}:${data.aws_caller_identity.current.account_id}:subnet/*",
      "arn:aws:ec2:${data.aws_region.main.name}:${data.aws_caller_identity.current.account_id}:key-pair/*",
      "arn:aws:ec2:${data.aws_region.main.name}:${data.aws_caller_identity.current.account_id}:network-interface/*",
      "arn:aws:ec2:${data.aws_region.main.name}:${data.aws_caller_identity.current.account_id}:security-group/*"
    ]
  }

  statement {
    sid = "VisualEditor2"
    actions = [
      "ec2:RebootInstances",
      "ec2:TerminateInstances",
      "ec2:StartInstances",
      "ec2:StopInstances"
    ]
    resources = ["arn:aws:ec2:${data.aws_region.main.name}:${data.aws_caller_identity.current.account_id}:instance/*"]
  }
}

resource "aws_iam_user_policy" "rancher" {
  name = "rancher"
  user = aws_iam_user.rancher.name
  policy = data.aws_iam_policy_document.rancher.json
}

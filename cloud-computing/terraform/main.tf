terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    key = "terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias = "identity_provider"
  region = var.identity_provider_aws_region
}

# Needed for cognito hosted ui certificate
# provider "aws" {
#   alias = "us-east-1"
#   region = "us-east-1"
# }

provider "cloudflare" {

}

resource "aws_route53_zone" "kubernetes" {
  name = var.cluster_domain_name
}

resource "cloudflare_zone" "base_domain" {
  account_id = var.cloudflare_account_id
  zone = var.base_domain_name
}

resource "cloudflare_zone_dnssec" "base_domain" {
  zone_id = cloudflare_zone.base_domain.id
}

resource "cloudflare_record" "route53_NS" {
  for_each = toset(aws_route53_zone.kubernetes.name_servers)
  zone_id = cloudflare_zone.base_domain.id
  name    = var.cluster_domain_name
  type    = "NS"
  value   = each.value
}

resource "cloudflare_email_routing_settings" "base_domain" {
  zone_id = cloudflare_zone.base_domain.id
  enabled = true
}

# There is no way of getting the DMARC hash
# resource "cloudflare_record" "dmarc" {
#   zone_id = cloudflare_zone.base_domain.id
#   name = "_dmarc"
#   type = "TXT"
#   value = "\"v=DMARC1;  p=none; rua=mailto:HASH-LOOKING-THING@dmarc-reports.cloudflare.net\""
# }

resource "cloudflare_email_routing_address" "admin" {
  account_id = var.cloudflare_account_id
  email      = var.admin_email_routing_destination
  depends_on = [cloudflare_email_routing_settings.base_domain]
}

resource "cloudflare_email_routing_rule" "admin" {
  zone_id = cloudflare_zone.base_domain.id
  name = "admin"
  enabled = true

  matcher {
    type = "literal"
    field = "to"
    value = var.admin_email
  }

  action {
    type = "forward"
    value = [cloudflare_email_routing_address.admin.email]
  }
}

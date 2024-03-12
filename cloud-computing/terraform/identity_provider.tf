# Confirm domain ownership for SES
resource "aws_ses_domain_identity" "kubernetes" {
  provider = aws.identity_provider
  domain = var.base_domain_name
}

# SES MAIL FROM
resource "aws_ses_domain_mail_from" "kubernetes" {
  provider = aws.identity_provider
  domain           = aws_ses_domain_identity.kubernetes.domain
  mail_from_domain = "bounce.${aws_ses_domain_identity.kubernetes.domain}"
}

# Creating the DNS records for SES MAIL FROM
resource "cloudflare_record" "ses_mx" {
  zone_id = cloudflare_zone.base_domain.id
  name    = aws_ses_domain_mail_from.kubernetes.mail_from_domain
  type    = "MX"
  ttl     = 300
  value   = "feedback-smtp.${var.identity_provider_aws_region}.amazonses.com"
  priority = 10
}

resource "cloudflare_record" "ses_spf" {
  zone_id = cloudflare_zone.base_domain.id
  name    = aws_ses_domain_mail_from.kubernetes.mail_from_domain
  type    = "TXT"
  ttl     = 300
  value   = "v=spf1 include:amazonses.com ~all"
}

# SES DKIM
resource "aws_ses_domain_dkim" "kubernetes" {
  provider = aws.identity_provider
  domain = aws_ses_domain_identity.kubernetes.domain
}

# Creating DNS records for SES DKIM
resource "cloudflare_record" "ses_dkim" {
  count   = 3
  zone_id = cloudflare_zone.base_domain.id
  name    = "${aws_ses_domain_dkim.kubernetes.dkim_tokens[count.index]}._domainkey"
  type    = "CNAME"
  ttl     = 1800
  value   = "${aws_ses_domain_dkim.kubernetes.dkim_tokens[count.index]}.dkim.amazonses.com"
}

# Wait until SES domain identity is verified
resource "aws_ses_domain_identity_verification" "kubernetes" {
  provider = aws.identity_provider
  domain = aws_ses_domain_identity.kubernetes.id
  depends_on = [
    cloudflare_record.ses_mx,
    cloudflare_record.ses_spf,
    cloudflare_record.ses_dkim
  ]
}

# User pool
resource "aws_cognito_user_pool" "kubernetes" {
  provider = aws.identity_provider
  name = "kubernetes"
  mfa_configuration = "ON"
  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
  deletion_protection = "ACTIVE"

  software_token_mfa_configuration {
    enabled = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name = "verified_email"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }

  email_configuration {
    email_sending_account = "DEVELOPER"
    source_arn = aws_ses_domain_identity.kubernetes.arn
    from_email_address = "Admin <no-reply@${aws_ses_domain_identity.kubernetes.domain}>"
  }

  depends_on = [aws_ses_domain_identity_verification.kubernetes]
}

resource "aws_cognito_user_group" "admin" {
  provider = aws.identity_provider
  name         = "admin"
  user_pool_id = aws_cognito_user_pool.kubernetes.id
}

resource "aws_cognito_user" "admin" {
  provider = aws.identity_provider
  user_pool_id = aws_cognito_user_pool.kubernetes.id
  username = var.admin_email
  desired_delivery_mediums = ["EMAIL"]

  attributes = {
    email = var.admin_email
  }

  depends_on = [cloudflare_email_routing_rule.admin] # wait for routing to send welcome email

  lifecycle {
    ignore_changes = [ attributes["email_verified"] ]
  }
}

resource "aws_cognito_user_in_group" "admin" {
  provider = aws.identity_provider
  user_pool_id = aws_cognito_user_pool.kubernetes.id
  group_name   = aws_cognito_user_group.admin.name
  username     = aws_cognito_user.admin.username
}

resource "aws_acm_certificate" "cognito_hosted_ui" {
  provider = aws.us-east-1
  domain_name = var.cognito_domain_name
  validation_method = "DNS"
  key_algorithm = "EC_prime256v1" # note EC_secp384r1 cannot be used by cloudfront
}

# Apply certificate validation
resource "cloudflare_record" "cognito_hosted_ui_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cognito_hosted_ui.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = cloudflare_zone.base_domain.id
  name            = each.value.name
  type            = each.value.type
  value           = each.value.record
  ttl             = 60
}

# Wait for validation to complete
resource "aws_acm_certificate_validation" "cognito_hosted_ui" {
  provider = aws.us-east-1
  certificate_arn         = aws_acm_certificate.cognito_hosted_ui.arn
  validation_record_fqdns = [for record in cloudflare_record.cognito_hosted_ui_validation : record.hostname]
}

# A record on root domain is required for user pool domain
resource "cloudflare_record" "root" {
  name    = var.base_domain_name
  type    = "A"
  zone_id = cloudflare_zone.base_domain.id
  value = "1.1.1.1" # arbitrary ip
}

# Needed for getting id token forgot password
resource "aws_cognito_user_pool_domain" "cognito_hosted_ui" {
  provider = aws.identity_provider
  domain       = var.cognito_domain_name
  user_pool_id = aws_cognito_user_pool.kubernetes.id
  certificate_arn = aws_acm_certificate.cognito_hosted_ui.arn
  depends_on = [cloudflare_record.root, aws_acm_certificate_validation.cognito_hosted_ui]
}

resource "cloudflare_record" "cognito_hosted_ui" {
  name    = aws_cognito_user_pool_domain.cognito_hosted_ui.domain
  type    = "CNAME"
  zone_id = cloudflare_zone.base_domain.id
  value = aws_cognito_user_pool_domain.cognito_hosted_ui.cloudfront_distribution
}

resource "aws_cognito_user_pool_client" "client" {
  provider = aws.identity_provider
  name = "client"
  user_pool_id = aws_cognito_user_pool.kubernetes.id
  explicit_auth_flows = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH"]
  callback_urls = ["http://localhost:8000", "https://${var.deploykf_domain_name}:${var.deploykf_https_port}/dex/callback"]
  logout_urls = ["http://localhost:8000", "https://${var.deploykf_domain_name}:${var.deploykf_https_port}/dex/callback"]
  supported_identity_providers = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = ["openid", "email", "profile"]
  prevent_user_existence_errors = "ENABLED"
  generate_secret = true

  auth_session_validity = 3
  refresh_token_validity = 30
  access_token_validity = 60
  id_token_validity = 60

  token_validity_units {
    access_token = "minutes"
    id_token = "minutes"
    refresh_token = "days"
  }
}

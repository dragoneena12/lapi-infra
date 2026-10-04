resource "aws_cognito_user_pool" "this" {
  name                = "isucon"
  deletion_protection = "ACTIVE"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  # ユーザーは管理者が招待する
  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  password_policy {
    minimum_length                   = 12
    require_lowercase                = true
    require_uppercase                = true
    require_numbers                  = true
    require_symbols                  = false
    temporary_password_validity_days = 7
  }

  mfa_configuration = "OPTIONAL"
  software_token_mfa_configuration {
    enabled = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = var.cognito_domain_prefix
  user_pool_id = aws_cognito_user_pool.this.id
}

# Grafana のロールは cognito:groups で決める（どちらにも属さなければ Viewer）
resource "aws_cognito_user_group" "grafana_admin" {
  name         = "grafana-admin"
  user_pool_id = aws_cognito_user_pool.this.id
  description  = "Grafana の Admin ロール"
}

resource "aws_cognito_user_group" "grafana_editor" {
  name         = "grafana-editor"
  user_pool_id = aws_cognito_user_pool.this.id
  description  = "Grafana の Editor ロール"
}

resource "aws_cognito_user_pool_client" "grafana" {
  name         = "grafana"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret                      = true
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid", "email", "profile"]
  supported_identity_providers         = ["COGNITO"]

  callback_urls = ["${var.grafana_url}/login/generic_oauth"]
  logout_urls   = ["${var.grafana_url}/login"]

  prevent_user_existence_errors = "ENABLED"
  enable_token_revocation       = true
}

output "cognito_issuer_url" {
  value = "https://${aws_cognito_user_pool.this.endpoint}"
}

output "cognito_domain_url" {
  value = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${aws_cognito_user_pool.this.region}.amazoncognito.com"
}

output "grafana_client_id" {
  value = aws_cognito_user_pool_client.grafana.id
}

output "grafana_client_secret" {
  value     = aws_cognito_user_pool_client.grafana.client_secret
  sensitive = true
}

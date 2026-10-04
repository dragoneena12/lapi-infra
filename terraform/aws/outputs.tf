output "isucon_cognito_issuer_url" {
  value = module.isucon_o11y.cognito_issuer_url
}

output "isucon_cognito_domain_url" {
  value = module.isucon_o11y.cognito_domain_url
}

output "isucon_grafana_client_id" {
  value = module.isucon_o11y.grafana_client_id
}

output "isucon_grafana_client_secret" {
  value     = module.isucon_o11y.grafana_client_secret
  sensitive = true
}

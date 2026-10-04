output "isucon_ingest_client_id" {
  value = module.isucon_o11y.ingest_client_id
}

output "isucon_ingest_client_secret" {
  value     = module.isucon_o11y.ingest_client_secret
  sensitive = true
}

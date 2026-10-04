output "ingest_client_id" {
  value = cloudflare_zero_trust_access_service_token.ingest.client_id
}

output "ingest_client_secret" {
  value     = cloudflare_zero_trust_access_service_token.ingest.client_secret
  sensitive = true
}

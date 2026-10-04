module "isucon_o11y" {
  source = "./modules/isucon-o11y"

  account_id      = var.cloudflare_account_id
  zone_id         = "ca1ef28780f706886f59b98c02003bfe" # lapi.tokyo
  origin_hostname = "k8s.lapi.tokyo"

  grafana_hostname = "isucon-grafana.lapi.tokyo"
  ingest_hostnames = [
    "isucon-prometheus.lapi.tokyo",
    "isucon-loki.lapi.tokyo",
    "isucon-tempo.lapi.tokyo",
    "isucon-pyroscope.lapi.tokyo",
  ]
}

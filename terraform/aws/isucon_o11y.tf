module "isucon_o11y" {
  source = "./modules/isucon-o11y"

  cognito_domain_prefix = "lapi-isucon"
  grafana_url           = "https://isucon-grafana.lapi.tokyo"
}

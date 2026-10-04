# 競技サーバーの Alloy は CF-Access-Client-Id / CF-Access-Client-Secret ヘッダーを付けて push する
resource "cloudflare_zero_trust_access_service_token" "ingest" {
  account_id = var.account_id
  name       = "isucon-o11y-ingest"
  duration   = "8760h"
}

resource "cloudflare_zero_trust_access_policy" "ingest" {
  account_id = var.account_id
  name       = "isucon-o11y-ingest"
  decision   = "non_identity"

  include = [
    {
      service_token = {
        token_id = cloudflare_zero_trust_access_service_token.ingest.id
      }
    },
  ]
}

resource "cloudflare_zero_trust_access_application" "ingest" {
  account_id = var.account_id
  name       = "isucon-o11y-ingest"
  type       = "self_hosted"

  destinations = [
    for hostname in var.ingest_hostnames : {
      type = "public"
      uri  = hostname
    }
  ]

  policies = [
    {
      id         = cloudflare_zero_trust_access_policy.ingest.id
      precedence = 1
    },
  ]

  # ブラウザではないので、未認証時はログイン画面へのリダイレクトではなく 401 を返す
  service_auth_401_redirect = true
  app_launcher_visible      = false
  session_duration          = "24h"
}

resource "cloudflare_dns_record" "this" {
  for_each = toset(concat([var.grafana_hostname], var.ingest_hostnames))

  zone_id = var.zone_id
  name    = each.key
  type    = "CNAME"
  content = var.origin_hostname
  proxied = true
  ttl     = 1
  comment = "isucon-o11y (terraform/cloudflare)"
}

# ケモフェスの運営ハーネス（k8s/tkf-harness）のダッシュボード
# ダッシュボード自体に認証がないので、kemofest.tokyo のメールアドレスの人だけを Access で通す
# ログイン画面を kemofest のチームドメインにするため、kemofest.tokyo のアカウントに置く
locals {
  tkf_harness_hostname = "harness.kemofest.tokyo"
}

resource "cloudflare_dns_record" "kemofest_tkf_harness" {
  provider = cloudflare.kemofest

  zone_id = "b11341dea66493d1a8cd906e5cf713ed" # kemofest.tokyo
  name    = local.tkf_harness_hostname
  type    = "CNAME"
  # 自宅 k8s の Ingress。proxied ではないので、別アカウントのゾーンから CNAME できる
  content = "k8s.lapi.tokyo"
  proxied = true
  ttl     = 1
  comment = "tkf-harness (lapi-infra terraform/cloudflare)"

  # Access で守られる前に公開されないよう、アプリを先に作る
  depends_on = [cloudflare_zero_trust_access_application.kemofest_tkf_harness]
}

resource "cloudflare_zero_trust_access_policy" "kemofest_tkf_harness" {
  provider = cloudflare.kemofest

  account_id = var.kemofest_cloudflare_account_id
  name       = "tkf-harness"
  decision   = "allow"

  include = [
    {
      email_domain = {
        domain = "kemofest.tokyo"
      }
    },
  ]
}

resource "cloudflare_zero_trust_access_application" "kemofest_tkf_harness" {
  provider = cloudflare.kemofest

  account_id = var.kemofest_cloudflare_account_id
  name       = "tkf-harness"
  type       = "self_hosted"

  destinations = [
    {
      type = "public"
      uri  = local.tkf_harness_hostname
    },
  ]

  policies = [
    {
      id         = cloudflare_zero_trust_access_policy.kemofest_tkf_harness.id
      precedence = 1
    },
  ]

  session_duration = "24h"
}

# cert-manager の HTTP-01 チャレンジ（Let's Encrypt）は Access にログインできないので、
# このパスだけ素通しする。パスがより具体的なアプリが優先される
resource "cloudflare_zero_trust_access_policy" "kemofest_tkf_harness_acme_challenge" {
  provider = cloudflare.kemofest

  account_id = var.kemofest_cloudflare_account_id
  name       = "tkf-harness-acme-challenge"
  decision   = "bypass"

  include = [
    {
      everyone = {}
    },
  ]
}

resource "cloudflare_zero_trust_access_application" "kemofest_tkf_harness_acme_challenge" {
  provider = cloudflare.kemofest

  account_id = var.kemofest_cloudflare_account_id
  name       = "tkf-harness-acme-challenge"
  type       = "self_hosted"

  destinations = [
    {
      type = "public"
      uri  = "${local.tkf_harness_hostname}/.well-known/acme-challenge"
    },
  ]

  policies = [
    {
      id         = cloudflare_zero_trust_access_policy.kemofest_tkf_harness_acme_challenge.id
      precedence = 1
    },
  ]

  app_launcher_visible = false
}

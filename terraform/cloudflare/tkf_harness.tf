# ケモフェスの運営ハーネス（k8s/tkf-harness）のダッシュボード
# ダッシュボード自体に認証がないので、kemofest.tokyo のメールアドレスの人だけを Access で通す
locals {
  tkf_harness_hostname = "tkf-harness.lapi.tokyo"
}

resource "cloudflare_dns_record" "tkf_harness" {
  zone_id = "ca1ef28780f706886f59b98c02003bfe" # lapi.tokyo
  name    = local.tkf_harness_hostname
  type    = "CNAME"
  content = "k8s.lapi.tokyo"
  proxied = true
  ttl     = 1
  comment = "tkf-harness (terraform/cloudflare)"

  # Access で守られる前に公開されないよう、アプリを先に作る
  depends_on = [cloudflare_zero_trust_access_application.tkf_harness]
}

resource "cloudflare_zero_trust_access_policy" "tkf_harness" {
  account_id = var.cloudflare_account_id
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

resource "cloudflare_zero_trust_access_application" "tkf_harness" {
  account_id = var.cloudflare_account_id
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
      id         = cloudflare_zero_trust_access_policy.tkf_harness.id
      precedence = 1
    },
  ]

  session_duration = "24h"
}

# cert-manager の HTTP-01 チャレンジ（Let's Encrypt）は Access にログインできないので、
# このパスだけ素通しする。パスがより具体的なアプリが優先される
resource "cloudflare_zero_trust_access_policy" "tkf_harness_acme_challenge" {
  account_id = var.cloudflare_account_id
  name       = "tkf-harness-acme-challenge"
  decision   = "bypass"

  include = [
    {
      everyone = {}
    },
  ]
}

resource "cloudflare_zero_trust_access_application" "tkf_harness_acme_challenge" {
  account_id = var.cloudflare_account_id
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
      id         = cloudflare_zero_trust_access_policy.tkf_harness_acme_challenge.id
      precedence = 1
    },
  ]

  app_launcher_visible = false
}

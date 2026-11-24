terraform {
  # aws login (login_session) の認証情報に S3 backend が対応したのが 1.15
  required_version = ">= 1.15"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.26"
    }
  }
}

# 認証は環境変数 CLOUDFLARE_API_TOKEN
provider "cloudflare" {}

# kemofest.tokyo は別のアカウントにあるので、トークンを分ける
provider "cloudflare" {
  alias     = "kemofest"
  api_token = var.kemofest_cloudflare_api_token
}

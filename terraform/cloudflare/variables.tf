variable "cloudflare_account_id" {
  description = "Cloudflare のアカウント ID"
  type        = string
}

variable "kemofest_cloudflare_api_token" {
  description = "kemofest.tokyo がある Cloudflare アカウントの API トークン"
  type        = string
  sensitive   = true
}

variable "kemofest_cloudflare_account_id" {
  description = "kemofest.tokyo がある Cloudflare アカウントの ID"
  type        = string
}

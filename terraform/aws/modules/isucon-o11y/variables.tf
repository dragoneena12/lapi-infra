variable "cognito_domain_prefix" {
  description = "Cognito ドメインのプレフィックス（<prefix>.auth.<region>.amazoncognito.com）"
  type        = string
}

variable "grafana_url" {
  description = "ISUCON 用 Grafana の URL（末尾スラッシュなし）"
  type        = string
}

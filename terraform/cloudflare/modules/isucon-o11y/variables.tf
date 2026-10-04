variable "account_id" {
  description = "Cloudflare のアカウント ID"
  type        = string
}

variable "ingest_hostnames" {
  description = "競技サーバーの Alloy が push する先のホスト名"
  type        = list(string)
}

variable "zone_id" {
  description = "DNS レコードを作るゾーンの ID"
  type        = string
}

variable "grafana_hostname" {
  description = "ISUCON 用 Grafana のホスト名"
  type        = string
}

variable "origin_hostname" {
  description = "各ホスト名の CNAME 先（自宅 k8s の Ingress）"
  type        = string
}

terraform {
  backend "s3" {
    bucket       = "lapi-infra-tfstate"
    key          = "cloudflare/terraform.tfstate"
    region       = "ap-northeast-1"
    encrypt      = true
    use_lockfile = true
  }
}

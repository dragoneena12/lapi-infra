# lapi-infra

## ansible

```
ansible-playbook site.yml
```

## k8s

```
kubectl oidc-login setup \
  --oidc-issuer-url=https://cognito-idp.ap-northeast-1.amazonaws.com/ap-northeast-1_tky7r42KU \
  --oidc-client-id=5l61n0hghju576hlnubnouam4o \
  --oidc-extra-scope=email

kubectl config set-cluster lapi-k8s --insecure-skip-tls-verify=true --server=https://lapi-k8s-cp01:6443
kubectl config set-context lapi-k8s --user=oidc-lapi --cluster=lapi-k8s
kubectl config use-context lapi-k8s
```

## terraform/aws

```
cd terraform/aws
terraform init
terraform apply
```

Grafana の OAuth クライアント情報は 1Password の `isucon-o11y` に登録する。

```
terraform output -raw isucon_grafana_client_id      # -> grafana-oauth-client-id
terraform output -raw isucon_grafana_client_secret  # -> grafana-oauth-client-secret
```

## terraform/cloudflare

state は terraform/aws と同じ S3 バケットに置くので、AWS の認証も必要。

Cloudflare の API トークンとアカウント ID は 1Password（vault `lapi-server` の `cloudflare-terraform` の `credential` と `account-id`）から `op run` で読み込む。

```
cd terraform/cloudflare
op run --env-file=.env.op -- terraform init
op run --env-file=.env.op -- terraform apply
```

ISUCON の競技サーバーの Alloy は、Cloudflare Access のサービストークンをヘッダーに付けて push する。

```
terraform output -raw isucon_ingest_client_id      # -> CF-Access-Client-Id
terraform output -raw isucon_ingest_client_secret  # -> CF-Access-Client-Secret
```

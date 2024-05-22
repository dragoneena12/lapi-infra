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

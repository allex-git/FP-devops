resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.6"

  create_namespace = true

  values = [
  <<EOF
server:
  extraArgs:
    - --insecure

  ingress:
    enabled: true
    ingressClassName: nginx
    hosts:
      - argocd.allex-devops.devops11.test-danit.com
    annotations:
      kubernetes.io/ingress.class: nginx
      external-dns.alpha.kubernetes.io/hostname: argocd.allex-devops.devops11.test-danit.com
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
EOF
]
}
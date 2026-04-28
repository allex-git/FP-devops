resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.5.4"
  create_namespace = true

  depends_on = [
    helm_release.nginx_ingress
  ]

values = [
<<EOF
configs:
  cm:
    timeout.reconciliation: 15s

server:
  extraArgs:
    - --insecure

  ingress:
    enabled: true
    ingressClassName: nginx
    hosts:
      - host: argocd.allex-devops.devops11.test-danit.com
        paths:
          - /
    annotations:
      kubernetes.io/ingress.class: nginx
      external-dns.alpha.kubernetes.io/hostname: argocd.allex-devops.devops11.test-danit.com

application:
  enabled: true

applications:
  python-app:
    namespace: argocd
    project: default

    source:
      repoURL: https://github.com/allex-git/FP-devops.git
      targetRevision: main
      path: kubernetes

    destination:
      server: https://kubernetes.default.svc
      namespace: default

    syncPolicy:
      automated:
        prune: true
        selfHeal: true
EOF
]
}
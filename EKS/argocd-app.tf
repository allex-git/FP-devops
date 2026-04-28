resource "kubernetes_manifest" "argocd_app" {
  depends_on = [
    helm_release.argocd
  ]

  manifest = yamldecode(file("${path.module}/../argocd/application.yaml"))
}
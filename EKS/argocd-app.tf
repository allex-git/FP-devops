variable "enable_argocd_app" {
  default = false
}

resource "kubernetes_manifest" "argocd_app" {
  count = var.enable_argocd_app ? 1 : 0

  manifest = yamldecode(file("${path.module}/../argocd/application.yaml"))

  depends_on = [
    helm_release.argocd
  ]
}
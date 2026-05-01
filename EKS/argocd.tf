resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.5.4"
  namespace        = "argocd"
  create_namespace = true

  values = [
    <<-EOT
    configs:
      cm:
        timeout.reconciliation: 20s
        url: "https://argocd.${var.name}.${var.zone_name}"

    server:
      ingress:
        enabled: false
      service:
        type: ClusterIP
      extraArgs:
        - --insecure
    EOT
  ]

  depends_on = [
    helm_release.nginx_ingress,
    #module.eks-external-dns,
    aws_eks_node_group.danit,
  ]
}

resource "kubernetes_ingress_v1" "argocd" {
  metadata {
    name      = "argocd-ingress"
    namespace = helm_release.argocd.namespace
    annotations = {
      "kubernetes.io/ingress.class"                  = "nginx"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
      "external-dns.alpha.kubernetes.io/hostname"    = "argocd.${var.name}.${var.zone_name}"
    }
  }

  spec {
    rule {
      host = "argocd.${var.name}.${var.zone_name}"
      http {
        path {
          path_type = "Prefix"
          path      = "/"
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.argocd,
    aws_eks_cluster.danit,
    aws_eks_node_group.danit,
    helm_release.nginx_ingress
  ]
}

data "kubernetes_secret" "argocd_secret" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }

  depends_on = [
    helm_release.argocd
  ]
}
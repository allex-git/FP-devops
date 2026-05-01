resource "kubernetes_manifest" "argocd_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"

    metadata = {
      name      = "python-app"
      namespace = "argocd"
    }

    spec = {
      project = "default"

      source = {
        repoURL        = "https://github.com/allex-git/FP-devops.git"
        targetRevision = "main"
        path           = "kubernetes"
      }

      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "python-app"
      }

      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }

        syncOptions = [
          "CreateNamespace=true"
        ]

        # CHANGED: retry makes sync more stable during first bootstrap
        retry = {
          limit = 5

          backoff = {
            duration    = "5s"
            factor      = 2
            maxDuration = "1m"
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.argocd,
    aws_eks_cluster.danit,
    aws_eks_node_group.danit
  ]
}
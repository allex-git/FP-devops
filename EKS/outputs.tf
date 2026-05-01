output "argocd_url" {
  description = "ArgoCD URL"
  value       = "https://argocd.${var.name}.${var.zone_name}"
}

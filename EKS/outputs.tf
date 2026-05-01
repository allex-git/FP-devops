output "argocd_url" {
  description = "ArgoCD URL"
  value       = "https://argocd.${var.name}.${var.zone_name}"
}

output "argocd_password" {
  description = "Basic password for ArgoCD"
  value       = data.kubernetes_secret.argocd_secret.data["password"]
  sensitive   = true
}
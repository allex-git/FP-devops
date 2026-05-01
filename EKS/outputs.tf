output "argocd_1_url" {
  description = "ArgoCD URL"
  value       = "https://argocd.${var.name}.${var.zone_name}"
}

output "argocd_2_password" {
  description = "ArgoCD admin password"
  value       = nonsensitive(data.kubernetes_secret.argocd_secret.data["password"])
  sensitive   = false
}
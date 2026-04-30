output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.danit.name
}

output "cluster_endpoint" {
  description = "EKS API endpoint"
  value       = aws_eks_cluster.danit.endpoint
}

output "cluster_ca" {
  description = "EKS cluster CA certificate"
  value       = aws_eks_cluster.danit.certificate_authority[0].data
}

output "oidc_issuer" {
  description = "EKS OIDC issuer URL"
  value       = aws_eks_cluster.danit.identity[0].oidc[0].issuer
}

output "oidc_arn" {
  description = "EKS OIDC provider ARN"
  value       = aws_iam_openid_connect_provider.openid_connect.arn
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN"
  value       = module.acm.acm_certificate_arn
}
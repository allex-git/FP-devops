module "eks-external-dns" {
  source  = "lablabs/eks-external-dns/aws"
  version = "2.1.1"

  # CHANGED: берём из remote_state
  cluster_identity_oidc_issuer     = data.terraform_remote_state.infra.outputs.oidc_issuer
  cluster_identity_oidc_issuer_arn = data.terraform_remote_state.infra.outputs.oidc_arn

  irsa_role_name_prefix = var.name

  settings = {
    "domainFilters[0]" = var.zone_name
    policy             = "upsert-only"
    txtOwnerId         = var.name
  }
}
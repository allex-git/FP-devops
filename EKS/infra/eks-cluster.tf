resource "aws_eks_cluster" "danit" {
  name     = var.name
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids         = module.vpc.private_subnets
    security_group_ids = [aws_security_group.danit_cluster.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController
  ]

  tags = merge(var.tags, {
    Name       = var.name
    created_by = var.name
  })
}
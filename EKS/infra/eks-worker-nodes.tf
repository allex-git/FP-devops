resource "aws_eks_node_group" "danit" {
  cluster_name    = aws_eks_cluster.danit.name
  node_group_name = "${var.name}-eks"
  node_role_arn   = aws_iam_role.danit_node.arn

  subnet_ids = module.vpc.private_subnets

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly
  ]

  tags = merge(
    var.tags,
    {
      Name       = "${var.name}-eks"
      created_by = var.created_by
    }
  )
}
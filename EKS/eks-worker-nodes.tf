resource "aws_eks_node_group" "danit" {
  cluster_name    = aws_eks_cluster.danit.name
  node_group_name = "${var.name}-node-group"
  node_role_arn   = aws_iam_role.danit-node.arn

  subnet_ids = module.vpc.private_subnets

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  tags = merge(var.tags, {
  Name       = "allex-devops"
  created_by = var.name
  })
}
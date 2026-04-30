resource "aws_security_group" "danit_cluster" {
  name        = "${var.name}-eks-sg"
  description = "Security group for EKS cluster"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name       = "${var.name}-eks-sg"
    created_by = var.name
  })
}

resource "aws_security_group_rule" "allow_https" {
  description       = "Allow HTTPS to EKS API"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.danit_cluster.id
}
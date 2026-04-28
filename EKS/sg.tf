resource "aws_security_group" "danit-cluster" {
  name   = "${var.name}-eks-sg"
  vpc_id = module.vpc.vpc_id

  egress {
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
resource "aws_iam_role" "node_group_role" {
  count = var.lab_enabled ? 1 : 0

  name = "${var.project_name}-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  count = var.lab_enabled ? 1 : 0

  role       = aws_iam_role.node_group_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  count = var.lab_enabled ? 1 : 0

  role       = aws_iam_role.node_group_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  count = var.lab_enabled ? 1 : 0

  role       = aws_iam_role.node_group_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_eks_node_group" "main" {
  count = var.lab_enabled ? 1 : 0

  cluster_name    = aws_eks_cluster.main[0].name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn   = aws_iam_role.node_group_role[0].arn

  subnet_ids = [
    aws_subnet.private_1[0].id,
    aws_subnet.private_2[0].id
  ]

  instance_types = ["t3.small"]
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.ecr_readonly,
    aws_iam_role_policy_attachment.cni_policy
  ]

  tags = {
    Name = "${var.project_name}-node-group"
  }
}

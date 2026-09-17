resource "aws_iam_role" "eks_cluster" {
  count = var.lab_enabled ? 1 : 0

  name = "${var.project_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  count = var.lab_enabled ? 1 : 0

  role       = aws_iam_role.eks_cluster[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "main" {
  count = var.lab_enabled ? 1 : 0

  name     = "${var.project_name}-cluster"
  role_arn = aws_iam_role.eks_cluster[0].arn
  version  = "1.33"

  vpc_config {
    subnet_ids = [
      aws_subnet.private_1[0].id,
      aws_subnet.private_2[0].id,
      aws_subnet.public_1[0].id,
      aws_subnet.public_2[0].id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

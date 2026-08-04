resource "aws_iam_role" "eks_cluster" {

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

// Attach the AmazonEKSClusterPolicy to the EKS cluster role


resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {

  role = aws_iam_role.eks_cluster.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}

// Create the EKS cluster

resource "aws_eks_cluster" "main" {

  name = "${var.project_name}-cluster"

  role_arn = aws_iam_role.eks_cluster.arn

  version = "1.33"

  vpc_config {

    subnet_ids = [

      aws_subnet.private_1.id,

      aws_subnet.private_2.id,

      aws_subnet.public_1.id,

      aws_subnet.public_2.id

    ]

  }

  depends_on = [

    aws_iam_role_policy_attachment.eks_cluster_policy

  ]

}
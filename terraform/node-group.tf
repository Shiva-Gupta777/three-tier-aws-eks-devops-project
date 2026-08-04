
// Create IAM Role for EKS Node Group

resource "aws_iam_role" "node_group_role" {

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



#############################################
# Attach Required IAM Policies
#############################################

# Allows Worker Nodes to join the EKS Cluster
resource "aws_iam_role_policy_attachment" "worker_node_policy" {

  role = aws_iam_role.node_group_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Allows Worker Nodes to pull Docker Images from Amazon ECR
resource "aws_iam_role_policy_attachment" "ecr_readonly" {

  role = aws_iam_role.node_group_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Required for Kubernetes Pod Networking
resource "aws_iam_role_policy_attachment" "cni_policy" {

  role = aws_iam_role.node_group_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


#############################################
# EKS Managed Node Group
#############################################

resource "aws_eks_node_group" "main" {

  cluster_name = aws_eks_cluster.main.name

  node_group_name = "${var.project_name}-node-group"

  node_role_arn = aws_iam_role.node_group_role.arn

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  instance_types = ["t3.small"]

  capacity_type = "ON_DEMAND"

  scaling_config {

    desired_size = 2

    min_size = 1

    max_size = 3
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
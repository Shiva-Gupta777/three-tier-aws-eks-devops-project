output "vpc_id" {
  description = "ID of the project VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

// Output the EKS cluster name

output "eks_cluster_name" {

  value = aws_eks_cluster.main.name

}

// Output the EKS cluster endpoint

output "node_group_name" {

  value = aws_eks_node_group.main.node_group_name

}

// Output the EKS cluster endpoint

output "node_group_status" {

  value = aws_eks_node_group.main.status

}
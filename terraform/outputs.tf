output "vpc_id" {
  description = "ID of the project VPC"
  value       = var.lab_enabled ? aws_vpc.main[0].id : null
}

output "public_subnet_ids" {
  description = "Public subnet IDs"

  value = var.lab_enabled ? [
    aws_subnet.public_1[0].id,
    aws_subnet.public_2[0].id
  ] : []
}

output "private_subnet_ids" {
  description = "Private subnet IDs"

  value = var.lab_enabled ? [
    aws_subnet.private_1[0].id,
    aws_subnet.private_2[0].id
  ] : []
}

output "eks_cluster_name" {
  value = var.lab_enabled ? aws_eks_cluster.main[0].name : null
}

output "node_group_name" {
  value = var.lab_enabled ? aws_eks_node_group.main[0].node_group_name : null
}

output "node_group_status" {
  value = var.lab_enabled ? aws_eks_node_group.main[0].status : null
}
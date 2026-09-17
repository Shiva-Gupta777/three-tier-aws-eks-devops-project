variable "aws_region" {
  description = "AWS region for the project"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used by the EKS infrastructure"
  type        = list(string)
}

variable "lab_enabled" {
  description = "Whether the complete DevOps lab infrastructure should exist"
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "environment" {
  description = "Environment (e.g., dev, staging, prod)"
  type        = string
}

variable "customer" {
  description = "Customer name"
  type        = string
}

variable "product" {
  description = "Product name"
  type        = string
}

variable "subnet_cidrs" {
  description = "CIDR blocks for subnets"
  type        = map(string)
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "security_group_rules" {
  description = "Security group rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "data_ebs_volume" {
  description = "Whether to create an additional EBS volume for data storage"
  type        = bool
}

variable "data_volume_size" {
  description = "Size of the EBS volume for data storage (in GB)"
  type        = number
}

variable "elastic_ip_attachment" {
  description = "Whether to attach an Elastic IP to the instance"
  type        = bool
}

variable "ssh_key_name" {
  description = "SSH key name for the instance"
  type        = string
}
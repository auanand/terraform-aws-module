variable "instance_name" {
  type        = string
  description = "Instance Name for the EC2 instance"

  validation {
    condition     = var.instance_name != ""
    error_message = "The instance name must not be empty."
  }
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "VPC ID for the instances"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the instances"
  type        = list(string)
}

variable "customer" {
  description = "Customer name"
  type        = string
}

variable "product" {
  description = "Product name"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, staging, prod)"
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
  default     = false
}

variable "data_volume_size" {
  description = "Size of the EBS volume for data storage (in GB)"
  type        = number
  default     = 20
}
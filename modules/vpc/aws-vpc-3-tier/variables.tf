variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "environment" {
  description = "Environment (e.g., dev, qa, prod)"
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
  type = object({
    dmz_a = string
    dmz_b = string
    app_a = string
    app_b = string
    db_a  = string
    db_b  = string
  })
}
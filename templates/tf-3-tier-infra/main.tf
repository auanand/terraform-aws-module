provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source             = "../../modules/vpc/aws-vpc-3-tier"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  environment        = var.environment
  customer           = var.customer
  product            = var.product
  subnet_cidrs       = var.subnet_cidrs
}

module "ec2_instance_jumpserver" {
  source             = "../../modules/ec2"
  instance_name      = var.instance_name
  instance_count     = var.instance_count
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = [module.vpc.dmz_subnet_ids[0]]
  customer           = var.customer
  product            = var.product
  environment        = var.environment
  security_group_rules = var.security_group_rules
  data_ebs_volume    = var.data_ebs_volume
  data_volume_size   = var.data_volume_size
  elastic_ip_attachment = var.elastic_ip_attachment
  ssh_key_name       = var.ssh_key_name
  depends_on         = [ module.vpc ]
}
# Terragrunt Configuration for AWS 3-Tier Infrastructure

## Introduction

This repository contains a Terragrunt configuration for deploying a 3-tier architecture on AWS using Terraform. The architecture includes a VPC with public and private subnets, EC2 instances, security groups, and optional EBS volumes. The setup is designed to provide a scalable, secure, and highly available infrastructure for web applications.

## Terragrunt Configuration

### Terragrunt File Sample

This is the main Terragrunt configuration file (`terragrunt.hcl`) used to deploy the 3-tier architecture.

```hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/auanand/terraform-aws-module.git//templates/tf-3-tier-infra/"
}

inputs = {
  aws_region           = "ap-south-1"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["ap-south-1a", "ap-south-1b"]
  environment          = "dev"
  customer             = "lup"
  product              = "webapp"
  subnet_cidrs = {
    dmz_a = "10.0.1.0/24"
    dmz_b = "10.0.2.0/24"
    app_a = "10.0.3.0/24"
    app_b = "10.0.4.0/24"
    db_a  = "10.0.5.0/24"
    db_b  = "10.0.6.0/24"
  }

  instance_name        = "jumpserver"
  instance_count       = 1
  ami_id               = "ami-01376101673c89611"
  instance_type        = "t2.micro"
  security_group_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  data_ebs_volume      = false
  data_volume_size     = 10
  elastic_ip_attachment = true
  ssh_key_name         = "lup-mumbai-key-may2024-1"
}
```

### Backend Configuration

The backend configuration for storing the Terraform state file in an S3 bucket.

```hcl
remote_state {
  backend = "s3"
  config = {
    bucket  = "terminolabs"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
    dynamodb_table = "s3-state-lock"
  }
}
```

## Inputs

| Name                   | Description                                      | Type          | Default                      | Required |
|------------------------|--------------------------------------------------|---------------|------------------------------|----------|
| `aws_region`           | AWS region                                       | `string`      | `ap-south-1`                 | yes      |
| `vpc_cidr`             | CIDR block for the VPC                           | `string`      | `10.0.0.0/16`                | yes      |
| `availability_zones`   | List of availability zones                       | `list(string)`| `["ap-south-1a", "ap-south-1b"]`| yes   |
| `environment`          | Environment (e.g., dev, staging, prod)           | `string`      | `dev`                        | yes      |
| `customer`             | Customer name                                    | `string`      | `lup`                        | yes      |
| `product`              | Product name                                     | `string`      | `webapp`                     | yes      |
| `subnet_cidrs`         | CIDR blocks for subnets                          | `map(string)` | `{"dmz_a":"10.0.1.0/24", ...}`| yes     |
| `instance_name`        | Name of the EC2 instance                         | `string`      | `jumpserver`                 | yes      |
| `instance_count`       | Number of instances to create                    | `number`      | `1`                          | yes      |
| `ami_id`               | AMI ID for the EC2 instance                      | `string`      | `ami-01376101673c89611`      | yes      |
| `instance_type`        | Instance type                                    | `string`      | `t2.micro`                   | yes      |
| `security_group_rules` | Security group rules                             | `list(object)`| `[{"from_port":22,"to_port":22,...}]`| yes |
| `data_ebs_volume`      | Whether to create an additional EBS volume       | `bool`        | `false`                      | no       |
| `data_volume_size`     | Size of the EBS volume for data storage (in GB)  | `number`      | `10`                         | no       |
| `elastic_ip_attachment`| Whether to attach an Elastic IP to the instance  | `bool`        | `true`                       | no       |
| `ssh_key_name`         | SSH key name for the instance                    | `string`      | `lup-mumbai-key-may2024-1`   | yes      |

## Outputs

| Name                | Description                           |
|---------------------|---------------------------------------|
| `instance_ids`      | IDs of the EC2 instances              |
| `security_group_ids`| IDs of the security groups            |
| `instance_names`    | Names of the EC2 instances            |

## How to Use

1. **Create a new directory for your Terraform configuration**:
   ```sh
   mkdir terraform-3-tier-infra
   cd terraform-3-tier-infra
   ```

2. **Create the `terragrunt.hcl` file in the `terraform-3-tier-infra` directory**.

3. **Initialize the Terraform configuration using Terragrunt**:
   ```sh
   terragrunt init
   ```

4. **Apply the Terraform configuration using Terragrunt**:
   ```sh
   terragrunt apply
   ```

   You will be prompted to confirm before the resources are created. Type `yes` to proceed.


# Terraform AWS 3-Tier VPC Module

## Introduction

This Terraform module creates a 3-tier Virtual Private Cloud (VPC) architecture on AWS. The architecture is designed to provide a high level of security and isolation for different components of an application, typically separating the application into three tiers:

1. **DMZ (Demilitarized Zone)**: This tier is exposed to the internet and contains public-facing resources.
2. **Application Layer (APP)**: This tier hosts application servers and is not directly exposed to the internet.
3. **Database Layer (DB)**: This tier hosts database servers and is strictly isolated from both the internet and the DMZ.

## Architecture Diagram

```plaintext
                Internet
                    |
               Internet Gateway
                    |
              -----------------
              |     DMZ       |
              -----------------
              |               |
          Public Subnets      NAT Gateway
              |               |
              -----------------
              |     APP       |
              -----------------
              |               |
          Private Subnets      |
              |               |
              -----------------
              |     DB        |
              -----------------
              |               |
          Private Subnets      |
              |               |
              -----------------
```

## Usage

To use this module, you need to define the required inputs and call the module in your Terraform configuration.

### Example

```hcl
provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source             = "git::https://github.com/auanand/terraform-aws-module.git//vpc/aws-vpc-3-tier?ref=v1.0"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["ap-south-1a", "ap-south-1b"]
  environment        = "prod"
  customer           = "lup"
  product            = "webapp"
  subnet_cidrs = {
    dmz_a = "10.0.1.0/24"
    dmz_b = "10.0.2.0/24"
    app_a = "10.0.3.0/24"
    app_b = "10.0.4.0/24"
    db_a  = "10.0.5.0/24"
    db_b  = "10.0.6.0/24"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "dmz_subnet_ids" {
  value = module.vpc.dmz_subnet_ids
}

output "app_subnet_ids" {
  value = module.vpc.app_subnet_ids
}

output "db_subnet_ids" {
  value = module.vpc.db_subnet_ids
}

output "dmz_route_table_id" {
  value = module.vpc.dmz_route_table_id
}

output "app_route_table_id" {
  value = module.vpc.app_route_table_id
}

output "db_route_table_id" {
  value = module.vpc.db_route_table_id
}

output "dmz_nacl_id" {
  value = module.vpc.dmz_nacl_id
}

output "app_nacl_id" {
  value = module.vpc.app_nacl_id
}

output "db_nacl_id" {
  value = module.vpc.db_nacl_id
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}
```

## Inputs

| Name                  | Description                                              | Type          | Default                | Required |
|-----------------------|----------------------------------------------------------|---------------|------------------------|----------|
| `vpc_cidr`            | CIDR block for the VPC                                   | `string`      | n/a                    | yes      |
| `environment`         | Environment (e.g., dev, staging, prod)                   | `string`      | n/a                    | yes      |
| `customer`            | Customer name                                            | `string`      | n/a                    | yes      |
| `product`             | Product name                                             | `string`      | n/a                    | yes      |
| `subnet_cidrs`        | CIDR blocks for subnets                                  | `map(string)` | n/a                    | yes      |
| `availability_zones`  | List of availability zones                               | `list(string)`| n/a                    | Yes      |

## Outputs

| Name                    | Description                       |
|-------------------------|-----------------------------------|
| `vpc_id`                | The ID of the VPC                 |
| `dmz_subnet_ids`        | The IDs of the DMZ subnets        |
| `app_subnet_ids`        | The IDs of the APP subnets        |
| `db_subnet_ids`         | The IDs of the DB subnets         |
| `dmz_route_table_id`    | The ID of the DMZ route table     |
| `app_route_table_id`    | The ID of the APP route table     |
| `db_route_table_id`     | The ID of the DB route table      |
| `dmz_nacl_id`           | The ID of the DMZ Network ACL     |
| `app_nacl_id`           | The ID of the APP Network ACL     |
| `db_nacl_id`            | The ID of the DB Network ACL      |
| `internet_gateway_id`   | The ID of the Internet Gateway    |
| `nat_gateway_id`        | The ID of the NAT Gateway         |

## How to Use

1. **Create a new directory for your Terraform configuration**:
   ```sh
   mkdir terraform-vpc
   cd terraform-vpc
   ```

2. **Create a new file named `main.tf` and paste the example usage code into it**.

3. **Initialize the Terraform configuration**:
   ```sh
   terraform init
   ```

4. **Apply the Terraform configuration**:
   ```sh
   terraform apply
   ```

   You will be prompted to confirm before the resources are created. Type `yes` to proceed.

# #######################################################################################
# Terraform AWS EC2 Instance Module

## Introduction

This Terraform module creates an AWS EC2 instance along with associated resources such as security groups and optional EBS volumes. The module allows for customization of instance names, security group rules, and additional data storage options.

## Usage

To use this module, you need to define the required inputs and call the module in your Terraform configuration.

### Example

```hcl
provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "path/to/vpc-module"
  # VPC module parameters here...
}

module "ec2_instance_jumpserver" {
  source         = "git::https://github.com/auanand/terraform-aws-module.git//ec2?ref=v1.1"
  instance_count = 1
  ami_id         = "ami-01376101673c89611"
  instance_type  = "t2.micro"
  ssh_key_name   = "prod-key"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = [module.vpc.dmz_subnet_ids[0]]
  instance_name  = "jumpserver"
  customer       = "dev"
  product        = "webapp"
  environment    = "dev"
  security_group_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  data_ebs_volume       = false
  data_volume_size      = 10
  elastic_ip_attachment = true
  depends_on = [module.vpc]
}

output "instance_ids" {
  value = module.ec2_instance_jumpserver.instance_ids
}

output "security_group_ids" {
  value = module.ec2_instance_jumpserver.security_group_ids
}

output "instance_names" {
  value = module.ec2_instance_jumpserver.instance_names
}
```

## Inputs

| Name                   | Description                                      | Type          | Default                      | Required |
|------------------------|--------------------------------------------------|---------------|------------------------------|----------|
| `instance_count`       | Number of instances to create                    | `number`      | `1`                          | yes      |
| `ami_id`               | AMI ID for the EC2 instance                      | `string`      | n/a                          | yes      |
| `instance_type`        | Instance type                                    | `string`      | `t2.micro`                   | yes      |
| `ssh_key_name`         | SSh Key Name                                     | `string`      | n/a                          | yes       
| `vpc_id`               | VPC ID for the instances                         | `string`      | n/a                          | yes      |
| `subnet_ids`           | List of subnet IDs for the instances             | `list(string)`| n/a                          | yes      |
| `instance_name`        | Name for the EC2 instance                        | `string`      | n/a                          | yes      |
| `customer`             | Customer name                                    | `string`      | n/a                          | yes      |
| `product`              | Product name                                     | `string`      | n/a                          | yes      |
| `environment`          | Environment (e.g., dev, staging, prod)           | `string`      | n/a                          | yes      |
| `security_group_rules` | Security group rules                             | `list(object)`| See `variables.tf` for default| yes     |
| `data_ebs_volume`      | Whether to create an additional EBS volume       | `bool`        | `false`                      | no       |
| `data_volume_size`     | Size of the EBS volume for data storage (in GB)  | `number`      | `20`                         | no       |
| `elastic_ip_attachment`| Whether to attach an Elastic IP to the instance  | `bool`        | `false`                      | no       |

## Outputs

| Name                | Description                           |
|---------------------|---------------------------------------|
| `instance_ids`      | IDs of the EC2 instances              |
| `security_group_ids`| IDs of the security groups            |
| `instance_names`    | Names of the EC2 instances            |

## How to Use

1. **Create a new directory for your Terraform configuration**:
   ```sh
   mkdir terraform-ec2
   cd terraform-ec2
   ```

2. **Create the above `main.tf` file in the `terraform-ec2` directory**.

3. **Initialize the Terraform configuration**:
   ```sh
   terraform init
   ```

4. **Apply the Terraform configuration**:
   ```sh
   terraform apply
   ```

   You will be prompted to confirm before the resources are created. Type `yes` to proceed.
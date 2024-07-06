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

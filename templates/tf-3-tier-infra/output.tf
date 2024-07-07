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

output "jumpserver_instance_ids" {
  value = module.ec2_instance_jumpserver.instance_ids
}

output "jumpserver_security_group_id" {
  value = module.ec2_instance_jumpserver.security_group_id
}
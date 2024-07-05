# Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "dmz_subnet_ids" {
  description = "The IDs of the DMZ subnets"
  value       = [aws_subnet.dmz_a.id, aws_subnet.dmz_b.id]
}

output "app_subnet_ids" {
  description = "The IDs of the APP subnets"
  value       = [aws_subnet.app_a.id, aws_subnet.app_b.id]
}

output "db_subnet_ids" {
  description = "The IDs of the DB subnets"
  value       = [aws_subnet.db_a.id, aws_subnet.db_b.id]
}

output "dmz_route_table_id" {
  description = "The ID of the DMZ route table"
  value       = aws_route_table.dmz.id
}

output "app_route_table_id" {
  description = "The ID of the APP route table"
  value       = aws_route_table.app.id
}

output "db_route_table_id" {
  description = "The ID of the DB route table"
  value       = aws_route_table.db.id
}

output "dmz_nacl_id" {
  description = "The ID of the DMZ Network ACL"
  value       = aws_network_acl.dmz.id
}

output "app_nacl_id" {
  description = "The ID of the APP Network ACL"
  value       = aws_network_acl.app.id
}

output "db_nacl_id" {
  description = "The ID of the DB Network ACL"
  value       = aws_network_acl.db.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}
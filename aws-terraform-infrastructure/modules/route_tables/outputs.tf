# modules/route_tables/outputs.tf

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.this.id
}

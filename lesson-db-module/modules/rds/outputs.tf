output "db_instance_id" {
  description = "Identifier of the RDS instance"
  value       = aws_db_instance.this.id
}

output "db_instance_address" {
  description = "DNS address of the RDS instance"
  value       = aws_db_instance.this.address
}

output "db_instance_endpoint" {
  description = "Connection endpoint (host:port) of the RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_port" {
  description = "Port number for the database"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Database name"
  value       = var.db_name
}

output "db_username" {
  description = "Master username"
  value       = var.username
}
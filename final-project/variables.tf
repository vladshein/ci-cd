variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_username" {
  type = string
}
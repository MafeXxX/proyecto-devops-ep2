variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "proyecto-semestral"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_pair_name" {
  description = "Nombre del Key Pair creado en AWS Academy"
}

variable "my_ip_cidr" {
  description = "Tu IP publica en formato CIDR. Ejemplo: 181.43.10.22/32"
  default     = "0.0.0.0/0"
}

# =========================
# MySQL
# =========================

variable "db_name" {
  default = "despachosdb"
}

variable "db_user" {
  default = "admin"
}

variable "db_password" {
  default = "admin123"
}

variable "db_root_password" {
  default = "123456"
}
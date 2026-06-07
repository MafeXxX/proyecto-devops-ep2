variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre base del proyecto para nombrar recursos"
  type        = string
  default     = "proyecto-semestral"
}

variable "vpc_cidr" {
  description = "CIDR principal de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR de la primera subred pública"
  type        = string
  default     = "10.0.10.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR de la segunda subred pública"
  type        = string
  default     = "10.0.20.0/24"
}

variable "availability_zone_1" {
  description = "Primera zona de disponibilidad"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "Segunda zona de disponibilidad"
  type        = string
  default     = "us-east-1b"
}

variable "node_instance_type" {
  description = "Tipo de instancia para los nodos trabajadores de EKS"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Cantidad deseada de nodos en el Node Group"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Cantidad mínima de nodos en el Node Group"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Cantidad máxima de nodos en el Node Group"
  type        = number
  default     = 2
}
output "cluster_name" {
  description = "Nombre del clúster EKS"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint del clúster EKS"
  value       = aws_eks_cluster.main.endpoint
}

output "frontend_ecr_url" {
  description = "URL del repositorio ECR del frontend"
  value       = aws_ecr_repository.frontend.repository_url
}

output "back_ventas_ecr_url" {
  description = "URL del repositorio ECR del backend de ventas"
  value       = aws_ecr_repository.back_ventas.repository_url
}

output "back_despachos_ecr_url" {
  description = "URL del repositorio ECR del backend de despachos"
  value       = aws_ecr_repository.back_despachos.repository_url
}

output "kubeconfig_command" {
  description = "Comando para conectar kubectl con el clúster EKS"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}

output "public_subnet_1_id" {
  description = "ID de la primera subred pública"
  value       = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  description = "ID de la segunda subred pública"
  value       = aws_subnet.public_2.id
}
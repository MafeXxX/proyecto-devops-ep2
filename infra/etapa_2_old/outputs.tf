output "frontend_public_ip" {
  value = aws_instance.frontend.public_ip
}

output "frontend_public_dns" {
  value = aws_instance.frontend.public_dns
}

output "backend_private_ip" {
  value = aws_instance.backend.private_ip
}

output "mysql_private_ip" {
  value = aws_instance.mysql.private_ip
}

output "frontend_url" {
  value = "http://${aws_instance.frontend.public_ip}"
}

output "backend_ventas_url" {
  value = "http://${aws_instance.backend.private_ip}:8080"
}

output "backend_despachos_url" {
  value = "http://${aws_instance.backend.private_ip}:8081"
}
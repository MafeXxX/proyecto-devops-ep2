provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_subnet" "public_frontend" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-frontend"
  }
}

resource "aws_subnet" "private_backend" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.project_name}-private-backend"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_frontend.id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public_frontend" {
  subnet_id      = aws_subnet.public_frontend.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

resource "aws_route_table_association" "private_backend" {
  subnet_id      = aws_subnet.private_backend.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "frontend_sg" {
  name        = "${var.project_name}-frontend-sg"
  description = "Acceso publico al frontend"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP publico"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH administracion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-frontend-sg"
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "${var.project_name}-backend-sg"
  description = "Backend privado"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Ventas desde frontend"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  ingress {
    description     = "Despachos desde frontend"
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  ingress {
    description     = "SSH desde frontend"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-backend-sg"
  }
}

resource "aws_security_group" "mysql_sg" {
  name        = "${var.project_name}-mysql-sg"
  description = "MySQL privado"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL desde backend"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  ingress {
    description     = "SSH desde frontend"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-mysql-sg"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_frontend.id
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  key_name               = var.key_pair_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = <<EOF
#!/bin/bash
dnf update -y
dnf install -y docker awscli curl

systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user

mkdir -p /usr/local/lib/docker/cli-plugins

curl -L --fail --retry 3 --connect-timeout 20 \
  https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose

chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

docker --version
docker compose version
EOF

  tags = {
    Name = "${var.project_name}-frontend-ec2"
  }
}

resource "aws_instance" "backend" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_backend.id
  private_ip             = "10.0.2.250"
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  key_name               = var.key_pair_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = <<EOF
#!/bin/bash
dnf update -y
dnf install -y docker awscli curl

systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user

mkdir -p /usr/local/lib/docker/cli-plugins

curl -L --fail --retry 3 --connect-timeout 20 \
  https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose

chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

docker --version
docker compose version
EOF

  tags = {
    Name = "${var.project_name}-backend-ec2"
  }
}

resource "aws_instance" "mysql" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_backend.id
  private_ip             = "10.0.2.251"
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  key_name               = var.key_pair_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = <<EOF
#!/bin/bash
dnf update -y
dnf install -y docker awscli curl

systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user

docker volume create mysql_data

docker run -d \
  --name mysql_db \
  -e MYSQL_ROOT_PASSWORD=${var.db_root_password} \
  -e MYSQL_DATABASE=${var.db_name} \
  -e MYSQL_USER=${var.db_user} \
  -e MYSQL_PASSWORD=${var.db_password} \
  -p 3306:3306 \
  -v mysql_data:/var/lib/mysql \
  --health-cmd="mysqladmin ping -h 127.0.0.1 -uroot -p${var.db_root_password} || exit 1" \
  --health-interval=5s \
  --health-timeout=3s \
  --health-retries=10 \
  --health-start-period=20s \
  --restart unless-stopped \
  mysql:8.0
EOF

  tags = {
    Name = "${var.project_name}-mysql-ec2"
  }
}
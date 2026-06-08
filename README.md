# Proyecto Semestral DevOps EP2 🚀

Proyecto desarrollado para la asignatura **ISY1101 - Introducción a Herramientas DevOps**, enfocado en la contenedorización, automatización de despliegue y operación de microservicios utilizando Docker, AWS EC2, Terraform y GitHub Actions.

El objetivo principal fue implementar una arquitectura basada en microservicios desplegada en AWS, aplicando principios DevOps reales como CI/CD, infraestructura como código y persistencia de datos.

---

# 📌 Arquitectura del Proyecto

El sistema está compuesto por:

- Frontend
- Backend Ventas
- Backend Despachos
- Base de Datos MySQL
- AWS EC2
- Docker
- GitHub Actions
- Terraform

---

# 🛠 Tecnologías Utilizadas

## Backend
- Java 17
- Spring Boot
- Maven
- MySQL

## Frontend
- HTML
- CSS
- JavaScript
- Nginx

## DevOps
- Docker
- Docker Compose
- GitHub Actions
- Terraform
- AWS EC2
- AWS ECR
- AWS CLI

---

# 📂 Estructura del Proyecto

```bash
proyecto-devops/
│
├── frontend/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── docker-compose.yml
│
├── backend-ventas/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── src/
│
├── backend-despachos/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── src/
│
├── terraform/
│   ├── etapa_1/
│   └── etapa_2/
│
├── .github/
│   └── workflows/
│       └── cd.yml
│
└── README.md
```

---

# 🐳 Contenedorización

Cada servicio fue dockerizado utilizando buenas prácticas DevOps:

✅ Multi-stage build  
✅ Optimización de capas  
✅ Separación de servicios  
✅ Variables de entorno  
✅ Persistencia mediante volúmenes  
✅ Automatización del despliegue  

---

# ⚙ Docker Compose

El proyecto utiliza `docker-compose.yml` para levantar el stack completo de servicios.

## Servicios principales

- frontend
- backend-ventas
- backend-despachos
- mysql

## Características

- Redes internas privadas
- Persistencia mediante volúmenes
- Variables de entorno
- Exposición controlada de puertos

---

# 💾 Persistencia de Datos

Se implementó persistencia utilizando Docker Volumes para evitar pérdida de información tras reinicios de contenedores.

## Volúmenes utilizados

```yaml
volumes:
  mysql_data:
```

## Beneficios

- Continuidad operativa
- Persistencia de la base de datos
- Separación entre contenedor y almacenamiento

---

# ☁ Infraestructura AWS

La infraestructura fue creada utilizando Terraform.

## Componentes desplegados

- VPC personalizada
- Subred pública
- Subred privada
- Security Groups
- EC2 Frontend
- EC2 Backend
- NAT Gateway
- Elastic IP
- Repositorios ECR

---

# 🔒 Seguridad Implementada

## Frontend
- Accesible desde Internet mediante IP pública.

## Backend
- Ejecutándose en subred privada.
- Acceso restringido mediante Security Groups.

## Docker
- Uso de contenedores aislados.
- Variables sensibles mediante GitHub Secrets.

---

# 🔄 Pipeline CI/CD

Se implementó automatización completa utilizando GitHub Actions.

## Flujo del Pipeline

```text
Push rama deploy
        ↓
Build Docker Image
        ↓
Push a ECR / Docker Hub
        ↓
Deploy automático en EC2
        ↓
Actualización del contenedor
```

## Características

- Trigger automático mediante rama `deploy`
- Build automatizado
- Publicación automática
- Deploy remoto mediante SSH
- Uso de GitHub Secrets

---

# 🔑 GitHub Secrets Utilizados

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
EC2_HOST
EC2_USER
SSH_PRIVATE_KEY
ECR_REPOSITORY
```

---

# 🚀 Ejecución Local

## 1. Clonar repositorio

```bash
git clone https://github.com/MafeXxX/proyecto-devops-ep2
```

---

## 2. Levantar servicios

```bash
docker compose up -d --build
```

---

## 3. Verificar contenedores

```bash
docker ps
```

---

# ☁ Despliegue en AWS

## Terraform

### Etapa 1

```bash
cd terraform/etapa_1

terraform init
terraform apply
```

### Etapa 2

```bash
cd terraform/etapa_2

terraform init
terraform apply
```

---

# 📡 Acceso al Sistema

## Frontend

```text
http://IP_PUBLICA_FRONTEND
```

## APIs Backend

```text
/api/ventas
/api/despachos
```

---

# 🧪 Validaciones Realizadas

✅ Comunicación Frontend → Backend  
✅ Persistencia de datos  
✅ Build automático  
✅ Deploy automático  
✅ Acceso restringido al backend  
✅ Funcionamiento en EC2  
✅ Docker Compose funcional  

---

# 📸 Evidencias Consideradas

- GitHub Actions ejecutándose
- Docker containers activos
- AWS Console
- Terraform Apply
- Frontend funcionando en navegador
- Comunicación entre microservicios

---

# 📚 Principios DevOps Aplicados

- Infraestructura como código
- Contenedorización
- Automatización CI/CD
- Control de versiones
- Persistencia de datos
- Escalabilidad
- Trazabilidad
- Mantenibilidad

---

# 👨‍💻 Autores

Proyecto desarrollado para:

**ISY1101 - Introducción a Herramientas DevOps**  
Duoc UC - 2025

---

# 📄 Referencias

Documentación oficial utilizada:

- Docker
- GitHub Actions
- AWS EC2
- AWS ECR
- Terraform
- Spring Boot

---

# ✅ Estado del Proyecto

🟢 Proyecto funcional  
🟢 Despliegue automatizado  
🟢 Persistencia operativa  
🟢 Comunicación Front ↔ Back funcional  
🟢 Infraestructura desplegada en AWS
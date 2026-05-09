# 🚀 Proyecto DevOps – Contenedorización y Despliegue Automatizado en AWS

Proyecto desarrollado para la asignatura **ISY1101 - Introducción a Herramientas DevOps** de Duoc UC.  
El objetivo de esta evaluación es implementar una arquitectura contenerizada utilizando Docker, automatizar el despliegue mediante GitHub Actions y desplegar los servicios en AWS EC2.

---

# 📌 Descripción del Proyecto

Este proyecto corresponde a una aplicación Full Stack compuesta por:

- 🎨 Frontend
- ⚙️ Backend
- 🗄️ Base de Datos
- ☁️ Infraestructura desplegada en AWS EC2
- 🔄 Pipeline CI/CD automatizado con GitHub Actions

La solución fue diseñada siguiendo principios DevOps modernos:

- Contenedorización con Docker
- Automatización CI/CD
- Persistencia mediante volúmenes Docker
- Uso de entornos separados
- Seguridad mediante subredes privadas y Security Groups
- Preparación para escalabilidad en AWS

---

# 🏗️ Arquitectura General

```text
Internet
   │
   ▼
Frontend EC2 (Pública)
   │
   ▼
Backend EC2 (Privada)
   │
   ▼
Base de Datos
```

## Componentes principales

| Componente | Tecnología |
|---|---|
| Frontend | React / Vite |
| Backend | Spring Boot |
| Base de Datos | MySQL |
| Contenedores | Docker |
| Orquestación | Docker Compose |
| CI/CD | GitHub Actions |
| Cloud | AWS EC2 |
| Infraestructura | Terraform |

---

# 🐳 Contenedorización

Cada servicio fue dockerizado utilizando buenas prácticas DevOps:

## Frontend

- Multi-stage build
- Nginx para servir archivos estáticos
- Optimización de tamaño de imagen
- Usuario no root

## Backend

- Multi-stage build
- OpenJDK 17
- Variables de entorno
- Usuario no root
- Persistencia mediante volúmenes

---

# 📂 Estructura del Proyecto

```text
project/
│
├── frontend/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── ...
│
├── backend/
│   ├── Dockerfile
│   └── ...
│
├── docker-compose.yml
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── ...
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
└── README.md
```

---

# ⚙️ Docker Compose

El proyecto utiliza `docker-compose.yml` para levantar los servicios.

## Servicios incluidos

- Frontend
- Backend
- Base de datos

## Funcionalidades implementadas

- Redes internas Docker
- Persistencia con volúmenes
- Variables de entorno
- Dependencias entre servicios
- Puertos expuestos correctamente

---

# 💾 Persistencia de Datos

Se implementó persistencia utilizando volúmenes Docker para asegurar continuidad operativa.

## Volúmenes utilizados

| Volumen | Uso |
|---|---|
| mysql_data | Persistencia de la base de datos |
| backend_logs | Logs del backend |

## Beneficios

- Los datos no se pierden al reiniciar contenedores
- Mayor estabilidad
- Facilita mantenimiento y recuperación

---

# ☁️ Infraestructura AWS

La solución fue desplegada utilizando AWS EC2.

## Arquitectura AWS

### Instancia Pública
- Frontend
- Acceso desde Internet

### Instancia Privada
- Backend
- Base de datos
- Acceso restringido

## Seguridad aplicada

- Security Groups
- Subred privada
- Restricción de acceso al Backend
- Solo el Frontend es accesible públicamente

---

# 🔄 Pipeline CI/CD

Se implementó automatización completa utilizando GitHub Actions.

## Flujo del pipeline

```text
Push rama deploy
        ↓
Build Docker Image
        ↓
Push Docker Hub / ECR
        ↓
Deploy automático EC2
        ↓
Actualización del servicio
```

## Automatizaciones implementadas

- Build automático
- Publicación de imágenes
- Deploy automático
- Reinicio de contenedores
- Uso de GitHub Secrets

---

# 🔐 Variables y Secrets

Las credenciales sensibles se gestionan mediante GitHub Secrets:

| Secret | Descripción |
|---|---|
| AWS_ACCESS_KEY_ID | Credencial AWS |
| AWS_SECRET_ACCESS_KEY | Credencial AWS |
| EC2_HOST | IP pública EC2 |
| EC2_USER | Usuario SSH |
| DOCKER_USERNAME | Usuario Docker Hub |
| DOCKER_PASSWORD | Password Docker Hub |

---

# ▶️ Ejecución Local

## 1. Clonar repositorio

```bash
git clone https://github.com/USUARIO/REPOSITORIO.git
```

## 2. Entrar al proyecto

```bash
cd proyecto
```

## 3. Levantar servicios

```bash
docker compose up -d --build
```

---

# 🌐 Acceso a Servicios

| Servicio | URL |
|---|---|
| Frontend | http://localhost |
| Backend | http://localhost:8080 |

---

# 🧪 Tecnologías Utilizadas

- Docker
- Docker Compose
- GitHub Actions
- AWS EC2
- Terraform
- React
- Spring Boot
- MySQL
- Nginx
- Git

---

# 📖 Principios DevOps Aplicados

Durante el desarrollo se aplicaron prácticas DevOps reales:

- ✅ Contenedorización
- ✅ Integración continua
- ✅ Despliegue continuo
- ✅ Infraestructura como código
- ✅ Automatización
- ✅ Persistencia de datos
- ✅ Control de versiones
- ✅ Seguridad y segmentación de red

Estas prácticas permiten:

- Mayor escalabilidad
- Mejor mantenibilidad
- Despliegues rápidos
- Menor tiempo de recuperación
- Mejor trazabilidad

---

# 👨‍💻 Integrantes

- Nombre Integrante 1
- Nombre Integrante 2

---

# 📚 Contexto Académico

Proyecto realizado para la Evaluación Parcial N°2 de la asignatura:

**ISY1101 - Introducción a Herramientas DevOps**  
Duoc UC – 2025

---

# ✅ Estado del Proyecto

✔️ Frontend dockerizado  
✔️ Backend dockerizado  
✔️ Persistencia implementada  
✔️ CI/CD funcional  
✔️ Deploy en AWS EC2  
✔️ Comunicación Front → Back  
✔️ Infraestructura automatizada con Terraform  

---

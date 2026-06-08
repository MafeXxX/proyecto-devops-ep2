# Proyecto Semestral DevOps EP3 🚀

Proyecto desarrollado para la asignatura **ISY1101 - Introducción a Herramientas DevOps**, enfocado en la contenedorización, orquestación, automatización de despliegue y operación de microservicios en AWS utilizando **Docker, Amazon ECR, Amazon EKS, Kubernetes, Terraform y GitHub Actions**.

El objetivo principal del proyecto es migrar una solución previamente desplegada con contenedores en EC2 hacia un entorno orquestado con Kubernetes, incorporando despliegue automatizado, balanceo de carga, comunicación interna entre servicios, métricas y autoscaling.

---

# 📌 Arquitectura del Proyecto

El sistema está compuesto por los siguientes servicios:

* **Frontend**
* **Backend Ventas**
* **Backend Despachos**
* **Base de Datos MySQL**
* **Amazon EKS**
* **Amazon ECR**
* **Kubernetes**
* **Terraform**
* **GitHub Actions**

Arquitectura general:

```text
Internet
   ↓
AWS LoadBalancer
   ↓
Frontend Service
   ↓
Frontend Pod - Nginx
   ↓
Backend Ventas Service / Backend Despachos Service
   ↓
MySQL Service
   ↓
MySQL Pod
```

El **Frontend** es el único servicio expuesto públicamente mediante un `Service` de tipo `LoadBalancer`.

Los backends y la base de datos se mantienen como servicios internos dentro del clúster mediante `ClusterIP`.

---

# 🛠 Tecnologías Utilizadas

## Backend

* Java 17
* Spring Boot
* Maven
* MySQL

## Frontend

* React / Vite
* JavaScript
* CSS
* Nginx

## DevOps / Cloud

* Docker
* Amazon ECR
* Amazon EKS
* Kubernetes
* Terraform
* GitHub Actions
* AWS CLI
* kubectl
* Metrics Server
* Horizontal Pod Autoscaler

---

# 📂 Estructura del Proyecto

```text
proyecto-devops-ep2/
│
├── front_despacho/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── src/
│
├── back-Ventas_SpringBoot/
│   └── Springboot-API-REST/
│       ├── Dockerfile
│       ├── pom.xml
│       └── src/
│
├── back-Despachos_SpringBoot/
│   └── Springboot-API-REST-DESPACHO/
│       ├── Dockerfile
│       ├── pom.xml
│       └── src/
│
├── infra/
│   ├── terraform/
│   │   ├── versions.tf
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   └── outputs.tf
│   │
│   └── k8s/
│       ├── namespace.yml
│       ├── secrets.yml
│       ├── mysql.yml
│       ├── backend-ventas.yml
│       ├── backend-despachos.yml
│       ├── frontend.yml
│       ├── hpa.yml
│       └── metrics-server.yml
│
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── cd.yml
│
├── docker-compose.yml
└── README.md
```

---

# 🐳 Contenedorización

Cada servicio fue dockerizado utilizando buenas prácticas DevOps:

* Dockerfile por servicio.
* Multi-stage build.
* Separación entre frontend y backends.
* Optimización de imágenes.
* Variables de entorno para configuración.
* Imágenes publicadas en Amazon ECR.
* Preparación para ejecución en Kubernetes.

Servicios dockerizados:

```text
Frontend
Backend Ventas
Backend Despachos
MySQL
```

---

# ☁ Infraestructura con Terraform

La infraestructura cloud se crea con Terraform desde:

```bash
infra/terraform
```

Terraform crea los siguientes recursos:

* VPC personalizada.
* Subredes públicas en distintas zonas de disponibilidad.
* Internet Gateway.
* Route Table pública.
* Repositorios Amazon ECR:

  * `proyecto-semestral-frontend`
  * `proyecto-semestral-back-ventas`
  * `proyecto-semestral-back-despachos`
* Clúster Amazon EKS.
* Node Group para los nodos trabajadores.
* Outputs para conexión al clúster y URLs de ECR.

---

# ⚙️ Comandos Terraform

## 1. Ingresar a la carpeta de Terraform

```bash
cd infra/terraform
```

## 2. Inicializar Terraform

```bash
terraform init
```

## 3. Validar configuración

```bash
terraform validate
```

## 4. Crear infraestructura

```bash
terraform apply
```

## 5. Conectar kubectl con EKS

Terraform entrega un output llamado `kubeconfig_command`.

Ejemplo:

```bash
aws eks update-kubeconfig --region us-east-1 --name proyecto-semestral-cluster
```

## 6. Validar nodos

```bash
kubectl get nodes
```

---

# ☸️ Kubernetes

Los manifiestos Kubernetes se encuentran en:

```bash
infra/k8s
```

## Archivos principales

| Archivo                 | Función                                          |
| ----------------------- | ------------------------------------------------ |
| `namespace.yml`         | Crea el namespace del proyecto                   |
| `secrets.yml`           | Guarda credenciales sensibles                    |
| `mysql.yml`             | Despliega MySQL y su Service interno             |
| `backend-ventas.yml`    | Despliega Backend Ventas y su Service interno    |
| `backend-despachos.yml` | Despliega Backend Despachos y su Service interno |
| `frontend.yml`          | Despliega Frontend y LoadBalancer público        |
| `hpa.yml`               | Configura autoscaling para los backends          |
| `metrics-server.yml`    | Habilita métricas para HPA                       |

---

# 🔐 Gestión de Secrets

Las variables sensibles se gestionan mediante Kubernetes Secret en:

```text
infra/k8s/secrets.yml
```

Variables incluidas:

```text
DB_USERNAME
DB_PASSWORD
MYSQL_ROOT_PASSWORD
MYSQL_USER
MYSQL_PASSWORD
```

Las variables no sensibles, como el nombre de la base de datos y el endpoint interno, se manejan mediante `ConfigMap` dentro de `mysql.yml`.

---

# 🗄 Base de Datos MySQL

MySQL se despliega como un pod interno dentro del clúster EKS.

El acceso se realiza mediante el Service:

```text
mysql-service
```

Los backends se conectan usando variables de entorno:

```text
DB_ENDPOINT=mysql-service
DB_PORT=3306
DB_NAME=despachosdb
```

---

# 🌐 Comunicación Frontend → Backend

El frontend utiliza Nginx como servidor web y proxy inverso.

Archivo:

```text
front_despacho/nginx.conf
```

Rutas configuradas:

```text
/api/v1/ventas     → backend-ventas-service:8080
/api/v1/despachos  → backend-despachos-service:8081
```

Esto permite que el frontend sea público, mientras los backends permanecen internos dentro del clúster.

---

# 📈 Autoscaling con HPA

Se configuró **Horizontal Pod Autoscaler** para los backends:

* `backend-ventas-hpa`
* `backend-despachos-hpa`

Configuración general:

```text
Min Pods: 1
Max Pods: 3
CPU Target: 50%
```

El clúster utiliza `metrics-server` para obtener métricas de CPU y memoria.

Comandos útiles:

```bash
kubectl get hpa -n proyecto-semestral
```

```bash
kubectl top pods -n proyecto-semestral
```

---

# 🔄 Pipeline CI/CD

El proyecto cuenta con dos workflows de GitHub Actions:

```text
.github/workflows/ci.yml
.github/workflows/cd.yml
```

---

## CI - Integración Continua

El workflow CI valida:

* Build del frontend.
* Build del backend ventas.
* Build del backend despachos.
* Formato y validación de Terraform.
* Sintaxis de manifiestos Kubernetes con `yamllint`.

Flujo:

```text
Push / Pull Request
        ↓
Build Docker
        ↓
Terraform fmt / validate
        ↓
Validación YAML Kubernetes
```

---

## CD - Despliegue Continuo

El workflow CD se encarga del despliegue automatizado hacia EKS.

Flujo:

```text
Push rama deploy / workflow manual
        ↓
Build imágenes Docker
        ↓
Push a Amazon ECR
        ↓
Conexión a Amazon EKS
        ↓
kubectl apply
        ↓
kubectl set image
        ↓
Rollout status
        ↓
Aplicación disponible
```

---

# 🔑 GitHub Secrets Utilizados

Para que GitHub Actions pueda conectarse a AWS y desplegar en EKS, se utilizan los siguientes secrets:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
AWS_ACCOUNT_ID
```

En AWS Academy, las credenciales son temporales. Por eso, cada vez que se reinicia el laboratorio, se deben actualizar los secrets de GitHub.

---

# 🚀 Despliegue en AWS EKS

## 1. Iniciar AWS Academy Lab

Antes de ejecutar Terraform o GitHub Actions, se debe iniciar el laboratorio de AWS Academy.

## 2. Configurar credenciales AWS locales

Verificar conexión:

```bash
aws sts get-caller-identity
```

## 3. Crear infraestructura

```bash
cd infra/terraform
terraform apply
```

## 4. Conectar kubectl

```bash
aws eks update-kubeconfig --region us-east-1 --name proyecto-semestral-cluster
```

## 5. Validar nodos

```bash
kubectl get nodes
```

## 6. Ejecutar pipeline CD

El despliegue se puede ejecutar:

* Automáticamente al hacer push a la rama `deploy`.
* Manualmente desde GitHub Actions usando `workflow_dispatch`.

---

# 📡 Acceso al Sistema

Para obtener la URL pública del frontend:

```bash
kubectl get svc frontend-service -n proyecto-semestral
```

El campo `EXTERNAL-IP` entrega la URL del LoadBalancer.

Ejemplo:

```text
http://a20d77eb6f5cf4e76aa3afcf54c6d408-2057190154.us-east-1.elb.amazonaws.com
```

---

# 🧪 Comandos de Validación

## Ver todos los recursos del namespace

```bash
kubectl get all -n proyecto-semestral
```

## Ver pods

```bash
kubectl get pods -n proyecto-semestral
```

## Ver servicios

```bash
kubectl get svc -n proyecto-semestral
```

## Ver logs Backend Ventas

```bash
kubectl logs deployment/backend-ventas -n proyecto-semestral
```

## Ver logs Backend Despachos

```bash
kubectl logs deployment/backend-despachos -n proyecto-semestral
```

## Ver logs Frontend

```bash
kubectl logs deployment/frontend -n proyecto-semestral
```

## Ver HPA

```bash
kubectl get hpa -n proyecto-semestral
```

## Ver métricas

```bash
kubectl top pods -n proyecto-semestral
```

---

# 📸 Evidencias Recomendadas

Para la presentación y defensa técnica se recomienda guardar capturas de:

* `terraform apply` exitoso.
* `terraform output`.
* `kubectl get nodes`.
* GitHub Actions CI exitoso.
* GitHub Actions CD exitoso.
* Repositorios ECR con imágenes publicadas.
* `kubectl get all -n proyecto-semestral`.
* `kubectl get svc -n proyecto-semestral`.
* Frontend funcionando desde navegador.
* Logs de los backends.
* `kubectl get hpa -n proyecto-semestral`.
* `kubectl top pods -n proyecto-semestral`.

---

# 📚 Principios DevOps Aplicados

* Infraestructura como código con Terraform.
* Contenedorización con Docker.
* Orquestación con Kubernetes.
* Automatización CI/CD con GitHub Actions.
* Registro de imágenes en Amazon ECR.
* Separación de configuración sensible mediante Secrets.
* Servicios internos mediante ClusterIP.
* Exposición pública controlada mediante LoadBalancer.
* Escalabilidad mediante HPA.
* Monitoreo básico mediante Metrics Server.
* Trazabilidad mediante commits y pipelines.

---

# 🧹 Eliminación de Infraestructura

Para eliminar los recursos creados en AWS:

```bash
cd infra/terraform
terraform destroy
```

Esto elimina:

* Clúster EKS.
* Node Group.
* VPC.
* Subredes.
* Repositorios ECR.
* Recursos asociados creados por Terraform.

> Nota: si los repositorios ECR son eliminados, también se eliminan las imágenes almacenadas en ellos. Para volver a desplegar, se debe ejecutar nuevamente el pipeline CD.

---

# 👨‍💻 Autores

Proyecto desarrollado para:

**ISY1101 - Introducción a Herramientas DevOps**
**Duoc UC - 2025**

---

# 📄 Referencias

Documentación oficial utilizada:

* Docker
* Kubernetes
* Amazon EKS
* Amazon ECR
* Terraform
* GitHub Actions
* Spring Boot
* MySQL
* Nginx

---

# ✅ Estado del Proyecto

🟢 Infraestructura creada con Terraform
🟢 Clúster EKS operativo
🟢 Node Group funcionando
🟢 Imágenes publicadas en Amazon ECR
🟢 CI exitoso
🟢 CD exitoso
🟢 Frontend público mediante LoadBalancer
🟢 Backends internos mediante ClusterIP
🟢 MySQL interno en Kubernetes
🟢 Comunicación Frontend → Backend funcional
🟢 HPA configurado con métricas reales

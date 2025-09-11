# Reto de Arquitectura Cloud: Aplicación Web Escalable en AWS
## Escenario

Una startup quiere lanzar una aplicación web interna para 50–100 usuarios activos diarios, con posibilidad de crecer a 1000 usuarios en el futuro. La app será un sistema de inventario con backend en Django y frontend en React.

## Quieren que la infraestructura sea:

Alta disponibilidad

Escalable automáticamente

Segura y monitoreada

Costo-efectiva

## Requisitos Técnicos

### Frontend

Desplegar React en un bucket S3 con hosting estático.

Servirlo a través de CloudFront con HTTPS (ACM para el certificado).

### Backend

Django servido con Gunicorn en contenedores Docker.

Ejecutándose en ECS con Fargate (serverless containers).

Balanceado con Application Load Balancer (ALB).

### Base de Datos

RDS PostgreSQL en Multi-AZ.

Backups automáticos habilitados.

### Seguridad

Todo el tráfico HTTPS forzado con ACM + ALB + CloudFront.

Acceso restringido a la DB (solo desde ECS).

Roles IAM mínimos necesarios.

### Escalabilidad

Auto Scaling en ECS con base en CPU y memoria.

Posibilidad de manejar picos de tráfico.

### CI/CD

Pipelines en GitHub Actions para:

Testear código.

Construir imágenes Docker.

Push a ECR.

Desplegar automáticamente a ECS.

### Monitoreo y Logs

Logs en CloudWatch (app + ECS + ALB).

Alarmas en métricas críticas (latencia alta, CPU/RAM, DB).
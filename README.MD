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

### Retos
Diseñar el diagrama de arquitectura con todos los componentes.

Explicar el flujo (desde que un usuario entra a la app hasta que recibe respuesta).

Justificar las decisiones de diseño (ej: por qué Fargate en lugar de EC2, por qué RDS en Multi-AZ, etc.).

Proponer optimizaciones de costo para la etapa inicial (pocos usuarios).
## Documentación

### 1. Diagrama de Arquitectura:
![Diagrama de arquitectura](img/diagrama.jpg)

### 2. Explicación de Flujo de la Arquitectura:
Todo empieza cuando el usuario hace una petición a través de un nombre de dominio gestionado en Amazon Route 53.
Este dominio apunta a Amazon CloudFront, el cual entrega los archivos estáticos almacenados en un bucket de Amazon S3 que contiene la aplicación frontend en React.
El frontend, a su vez, realiza peticiones a una API REST expuesta en otro dominio gestionado por Route 53, que apunta a un Application Load Balancer (ALB) desplegado en una subnet pública dentro de la VPC.
El ALB distribuye las peticiones hacia el backend implementado en Amazon ECS con Fargate, el cual se encuentra en una subnet privada. ECS Fargate ejecuta los contenedores de la aplicación Django, y el servicio puede escalar automáticamente el número de tareas según la carga (Auto Scaling).
Cuando el backend necesita interactuar con la base de datos, se conecta a un Amazon RDS configurado en Multi-AZ, que se encuentra también en subnets privadas (una en cada AZ).
La base de datos está protegida por un Security Group que solo permite acceso desde el backend, garantizando la seguridad de las comunicaciones internas.
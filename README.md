# AWS Infrastructure Lab with Terraform & LocalStack

Este repositorio contiene un laboratorio práctico de **Infraestructura como Código (IaC)** que simula un entorno de red de AWS utilizando **Terraform** y **LocalStack**. El objetivo es desplegar una arquitectura base segura y persistente para un servidor de automatización (Jenkins) sin incurrir en costes de nube real.

## 🚀 Descripción del Proyecto

La arquitectura despliega una red virtual aislada (VPC) con segmentación de subredes, reglas de firewall mediante Security Groups y almacenamiento persistente en S3. Todo el entorno se ejecuta localmente dentro de contenedores Docker, garantizando un entorno de desarrollo rápido, gratuito e independiente.

<img width="857" height="555" alt="Project_LocalStack_Terraform_AWS" src="https://github.com/user-attachments/assets/6c2649d8-06ff-49d4-853b-e33ff24ca06c" />

## 🛠️ Tecnologías Utilizadas

* **Terraform**: Orquestación de infraestructura.
* **LocalStack**: Emulación de servicios de AWS (EC2, S3, IAM, VPC).
* **Docker & Docker Compose**: Contenerización del entorno de simulación.
* **AWS CLI / awslocal**: Interacción con la infraestructura desplegada.

## 🏗️ Arquitectura Desplegada

* **Networking**: VPC (`10.0.0.0/16`) con una Subred Pública (`10.0.1.0/24`) e Internet Gateway.
* **Seguridad**: Security Group con acceso restringido al puerto `8080` para tráfico entrante.
* **Cómputo**: Instancia EC2 simulada dentro de la subred pública.
* **Almacenamiento**: Bucket S3 configurado para la persistencia de datos de la aplicación.

## 🧠 Retos Técnicos y Soluciones

Durante el desarrollo de este laboratorio, se identificaron y resolvieron los siguientes desafíos técnicos propios de la emulación local:

1. **Error de Comunicación S3 (HEAD / 500)**: Terraform intentaba validar el bucket mediante subdominios DNS. 
   * **Solución**: Se forzó el uso de `s3_use_path_style = true` en el proveedor para que las peticiones apunten correctamente a la estructura de rutas de LocalStack (`localhost:4566/bucket`).
2. **Mapeo de Puertos en Docker**: El puerto 8080 de la instancia simulada no era accesible desde el host.
   * **Solución**: Se ajustó la configuración de `docker-compose.yml` para exponer los puertos necesarios y permitir el acceso local a los servicios.
3. **Persistencia Efímera**: Los datos se perdían al reiniciar el contenedor.
   * **Solución**: Se implementó una lógica de almacenamiento en S3 para simular backups de configuración.

## 💻 Cómo Ejecutar el Laboratorio

### Requisitos Previos
* Docker & Docker Compose instalados.
* Terraform
* Python/Pip para instalar `awscli-local`.

### Pasos
1. **Levantar LocalStack**:
   ```bash
   docker-compose up -d
   terraform init
   terraform apply --auto-approve

2. **Verificar Recursos**:
   ```bash
   awslocal s3 ls
   awslocal ec2 describe-instances --output table
   
3. **Limpieza**
Para eliminar todos los recursos creados y evitar el consumo de memoria local:
 ```bash
terraform destroy --auto-approve
docker-compose down
```
## 🔍 Verificación y Troubleshooting 

Para asegurar que cada componente se ha desplegado correctamente y se comporta como en un entorno real de AWS, sigue estos pasos de verificación:

### 1. Networking: Validación de la VPC y Subred
Comprobamos que la red existe y que la segmentación de IP es la correcta.
* **Comando:**
  ```bash
  awslocal ec2 describe-vpcs --query "Vpcs[*].{ID:VpcId,CIDR:CidrBlock}" --output table
  ```
  <img width="338" height="137" alt="image" src="https://github.com/user-attachments/assets/13532011-70bd-402f-b071-b7c58f83a11f" />

```bash
awslocal s3 ls s3://jenkins-persistence-bucket/
```
<img width="378" height="20" alt="image" src="https://github.com/user-attachments/assets/caeba727-df27-4c91-bf39-9fce66aa94b2" />

```bash
awslocal ec2 describe-instances --query "Reservations[*].Instances[*].{ID:InstanceId,Status:State.Name,IP:PrivateIpAddress,SG:SecurityGroups[0].GroupName}" --output table
```
<img width="307" height="102" alt="image" src="https://github.com/user-attachments/assets/c36111e3-310a-4196-a89f-38d54a450a96" />



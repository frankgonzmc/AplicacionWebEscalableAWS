# Subnet group para RDS, Aqui le indicamos al recurso las subnets donde se replicará
resource "aws_db_subnet_group" "rds-subnet-group"{
    name = "rds-subnet-group"
    subnet_ids = var.subnet_ids
    tags = {
        Name = "rds-subnet-group"
    }
}

#RDS
resource "aws_db_instance" "my-db-rds"{
    identifier = "mydb"
    engine = "postgres"
    engine_version = "17.0"
    instance_class = "t2.micro"
    allocated_storage = 20 #Almacenamiento inicial (GB)
    max_allocated_storage = 100 #Permite autoscaling, la ase de datos se adaptará según su creciemiento hasta 100 GB
    
    #Entorno de la db
    db_name = "myapp"
    username = "admin"
    password = "123" #Solo para este laboratorio
    port = 5432

    vpc_security_group_ids = [var.rds-sg]
    db_subnet_group_name = aws_db_subnet_group.rds-subnet-group.name #Asignar nuetsra subnet group

    multi_az = true
    storage_encrypted = true
    backup_retention_period = 7 #Definimos en cuantos dias se guardan los backups
    skip_final_snapshot = true #Solo en lab, si eliminamos la db no guaradara snapshot

    tags = {
        Name = "my-rds"
    }

}


# Outputs
output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.my-db-rds.address
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.my-db-rds.port
}
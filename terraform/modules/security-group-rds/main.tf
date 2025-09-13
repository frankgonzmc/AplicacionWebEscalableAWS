resource "aws_security_group" "sg-rds"{
    name = "sg-rds"
    description = "Grupo de seguridad para RDS"
    vpc_id = var.vpc_id
    #Entrada: permitir solo de ECS
    ingress{
        description = "Permitir trafico DB de ECS"
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        security_groups = [var.sg-ecs]
    }
    # Salida: permitir todo (necesario para actualizaciones y replicación interna)
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "sg-rds"
    }
}
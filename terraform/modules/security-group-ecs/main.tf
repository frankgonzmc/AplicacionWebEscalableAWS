resource "aws_security_group" "sg-ecs"{
    name = "sg-ecs"
    description = "Grupo de seguridad para ecs/backend"
    vpc_id = var.vpc_id
    #Entrada, permitir solo trafico entrante de mi ALB
    ingress{
        description = "Permitir todo el trafico de ALB"
        from_port = 8000 # port 8000, donde corre Django
        to_port = 8000
        protocol = "tcp"
        security_groups = [var.sg-alb]
    }
    #Salida, permitir todo
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "sg-ecs"
    }
}
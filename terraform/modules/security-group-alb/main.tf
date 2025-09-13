resource "aws_security_group" "alb-sg"{
    name = "alb-sg"
    description = "Grupo de seguridad para Aplication Load Balancer"
    vpc_id = var.vpc_id
    #Entrada HTTP y HTTPS desde cualquier lado
    ingress{
        description = "Permitir HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        description = "Permitir HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    #Salida, permitir todo para comunicacion con ecs
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sg-alb"
    }
}
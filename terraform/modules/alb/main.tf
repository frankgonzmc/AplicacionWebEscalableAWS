#Application load balancer
resource "aws_lb" "app-alb"{
    name = "app-alb"
    internal = false #Sera publico
    load_balancer_type = "application"
    security_groups = [var.alb_sg_id]
    subnets = var.public_subnets
    tags = {
        Name = "app-alb"
    }
}

#Target Group para ECS (Recibe trafico de ALB)
resource "aws_lb_target_group" "ecs_tg"{
    name = "ecs-tg"
    port = 8000 #Puerto del container donde se recibe trafico
    protocol = "HTTP"
    vpc_id = var.vpc_id
    target_type = "ip" #Usamos Fargate

    #Revisar si el target esta vivo
    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200-399" #Rangos de códigos de respuesta válidos (ej: 200 OK, 302 redirect).
        interval = 30 # Cada 30 segundos hacer el chequeo
        timeout = 5 #Si en 5 segundos no responde se considera fallo
        healthy_threshold = 2 # Se necesita dos respuestas existosas consecutivas para considerar al target sano
        unhealthy_threshold = 2 # Se necesitan dos fallos consecutivos para considerarlo como fallo
    }

    tags = {
        Name = "ecs-target-group"
    }
}

#Listener en puerto 80
resource "aws_lb_listener" "http_listener"{
    load_balancer_arn = aws_lb.app-alb.arn
    port = 80 #Puerto de escucha del ALB
    protocol = "HTTP"
    default_action {
        type = "forward" #Redirigir al target group
        target_group_arn = aws_lb_target_group.ecs_tg.arn
    }
}

#OUTPUTS
output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.ecs_tg.arn
}

resource "aws_vpc" "my-vpc"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
}

#En region 1
resource "aws_subnet" "public-subnet-az1"{
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = "10.0.0.0/18"
    availability_zone = var.availability_zone[0]
    map_public_ip_on_launch = false #En este caso no asignamos ip publica porque ALB trabaja con DNS
    tags = {
        Name = "subnet-publica-az1"
    }
}

resource "aws_subnet" "private-subnet-az1"{
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = "10.0.64.0/18"
    availability_zone = var.availability_zone[0]
    map_public_ip_on_launch = false #No asignar ip publica en la subnet privada
    tags = {
        Name = "subnet-privada-az1"
    }
}
#En region 2
resource "aws_subnet" "public-subnet-az2"{
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = "10.0.128.0/18"
    availability_zone = var.availability_zone[1]
    map_public_ip_on_launch = false #En este caso no asignamos ip publica porque ALB trabaja con DNS
    tags = {
        Name = "subnet-publica-az2"
    }
}

resource "aws_subnet" "private-subnet-az2"{
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = "10.0.192.0/18"
    availability_zone = var.availability_zone[1]
    map_public_ip_on_launch = false #No asignar ip publica en la subnet privada
    tags = {
        Name = "subnet-privada-az2"
    }
}

resource "aws_internet_gateway" "my-gateway"{
    vpc_id = aws_vpc.my-vpc.id
    tags = {
        Name = "my-gateway"
    }
}

#Apuntar hacia internet gateway con mi tabla de rutas
resource "aws_route_table" "my-route-table-subnet-public"{
    vpc_id = aws_vpc.my-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-gateway.id
    }
    tags = {
        Name = "my-route-table-for-public-subnets"
    }
}

#Asociar la tabla de ruta a la subnet publica de la region 1
resource "aws_route_table_association" "asociate-route-table-publicsubnet-az1"{
    subnet_id = aws_subnet.public-subnet-az1.id
    route_table_id = aws_route_table.my-route-table-subnet-public.id
}

#Asociar la tabla de ruta a la subnet publica de la region 2
resource "aws_route_table_association" "asociate-route-table-publicsubnet-az2"{
    subnet_id = aws_subnet.public-subnet-az2.id
    route_table_id = aws_route_table.my-route-table-subnet-public.id
}

#OUTPUTS PARA NUESTRA VPC
output "private_subnet_ids" {
  value = [
    aws_subnet.private-subnet-az1.id,
    aws_subnet.private-subnet-az2.id
  ]
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public-subnet-az1.id,
    aws_subnet.public-subnet-az2.id
  ]
}
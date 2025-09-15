variable "subnet_ids" {
  description = "Lista de subnets privadas donde desplegar el RDS"
  type        = list(string)
}

variable "rds-sg"{
    type = string
}
variable "availability_zone" {
    description = "Zonas de disponibilidad dentro de mi vpc"
    type = list(string)
    default = [ "us-east-1a", "us-east-1b" ]
}
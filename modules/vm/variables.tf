variable "resource_group_name" {
    type = string
    description = "grupo de recursos de las vm"
}

variable "location" {
    type = string
    description = "region"
}

variable "subnet_id" {
    type = string
    description = "id de la subnet de los servidores"
}

variable "user" {
    type = string
    description = "usuario ssh"
}

variable "name_function" {
    type = string
    description = "prefijo de los recursos"
}
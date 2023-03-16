# Input Variables

variable "project_name" {
  description = ""
  type        = string
  default     = "Artists"
}

variable "region" {
  description = "Region for deployment, must match the region in provider.tf"

  type    = string
  default = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"

  type    = string
  default = "10.1.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the single subnet"

  type    = string
  default = "10.1.0.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the subnet, this will be pre-pended to the region (only use a,b,c)"

  type    = string
  default = "a"
}

variable "my_network" {
  description = "IPv4 CIDR for your network to allow traffic to deployed services"

  type     = string
  nullable = false
}

variable "ingress_specs" {
  description = ""
  type = object({
    port     = number
    protocol = string
  })

  default = {
    port     = 80
    protocol = "tcp"
  }
}

variable "service_specs" {
  description = ""
  type = object({
    name  = string
    image = string

    memory = string
    cpu    = string
  })

  default = {
    name   = "ArtistsAPI"
    image  = null
    memory = "512"
    cpu    = "256"
  }

  nullable = false
}

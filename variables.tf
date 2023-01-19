variable "aws_region" {
  default = "eu-north-1"
}

# -------- database variables -------- #

variable "db_name" {
    type = string
}

variable "db_username" {
    type = string
    sensitive = true
}

variable "db_password" {
    type = string
    sensitive = true
}
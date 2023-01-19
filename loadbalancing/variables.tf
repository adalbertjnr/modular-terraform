# ----------------------- LOADBALANCING/variables.tf --------------------------- #

variable "pub_subnetcidr" {}

variable "security_groups" {}

variable "tg_port" {}

variable "tg_protocol" {}

variable "lb_healthy_threshold" {}

variable "lb_unhealthy_threshold" {}

variable "lb_timeout" {}

variable "lb_interval" {}

variable "vpc_id" {}
# ----------------------- LOADBALANCING/main.tf --------------------------- #

resource "aws_lb" "lb" {
    name = "loadbalancer"
    subnets = var.pub_subnetcidr
    security_groups = [var.security_groups]
    idle_timeout = 400
}
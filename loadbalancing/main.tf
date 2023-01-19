# ----------------------- LOADBALANCING/main.tf --------------------------- #

resource "aws_lb" "lb" {
    name = "loadbalancer"
    subnets = var.pub_subnetcidr
    security_groups = [var.security_groups]
    idle_timeout = 400
}

resource "aws_lb_target_group" "tg" {
    name = "tg-lb-${substr(uuid(), 0, 3)}"
    port = var.tg_port
    protocol = var.tg_protocol
    vpc_id = var.vpc_id
    health_check {
        healthy_threshold = var.lb_healthy_threshold
        unhealthy_threshold = var.lb_unhealthy_threshold
        timeout = var.lb_timeout
        interval = var.lb_interval
    }
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.lb.arn
    port = var.listener_port
    protocol = var.listener_protocol
    default_action {
        type = "foward"
        target_group_arn = aws_lb_target_group.tg.arn
    }
}
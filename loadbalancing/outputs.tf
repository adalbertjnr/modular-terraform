output "lb_target_group_arn_out" {
    value = aws_lb_target_group.tg.arn
}

output "lb_dns" {
    value = aws_lb.lb.dns_name
}
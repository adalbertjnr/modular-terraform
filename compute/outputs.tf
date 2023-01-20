# -------------------------- COMPUTE/outputs.tf ---------------------------#

output "instance_info" {
    value = aws_instance.ec2[*]
    sensitive = true
}

output "instance_port" {
    value = aws_lb_target_group_attachment.ec2_att[0].port
}
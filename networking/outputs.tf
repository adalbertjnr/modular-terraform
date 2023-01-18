# MODULE --------------- networking/outputs.tf ------------------- MODULE
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "db_subnet_group" {
    value = aws_db_subnet_group.rds_subnet.*.name
}

output "db_security_group" {
    value = [aws_security_group.sec_grp["rds"].id]
}
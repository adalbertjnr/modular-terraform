# MODULE------------------  database/main.tf  -------------------- MODULE

resource "aws_db_instance" "db" {
    allocated_storage = var.db_storage
    db_name = var.db_name
    engine = "mysql"
    engine_version = var.db_engine_version
    instance_class = var.db_instance_class
    username = var.db_username
    password = var.db_password
    skip_final_snapshot = var.skip_db_snapshot
    db_subnet_group_name = var.db_subnet_group_name
    vpc_security_group_ids = var.vpc_security_group_ids
    identifier = var.db_identifier
    
    tags = {
        Name = "my-db"
    }
}
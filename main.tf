# ROOT/main.tf --------------------------------

module "networking" {
  source          = "./networking"
  vpc_cidr        = local.vpc_cidr
  pub_counter     = 2
  priv_counter    = 3
  max_subnets     = 10
  pub_subnetcidr  = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  priv_subnetcidr = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  security_groups = local.security_groups
  sg_access_from  = local.sg_access_from
  db_subnet_group = true
}

module "database" {
source = "./database"
db_storage = 10
db_name = var.db_name
db_engine_version = "5.7.33"
db_instance_class = "db.t3.micro"
db_username = var.db_username
db_password = var.db_password
skip_db_snapshot = true
db_subnet_group_name = module.networking.db_subnet_group[0]
vpc_security_group_ids = module.networking.db_security_group
db_identifier = "rds-database"

}

module "loadbalancing" {
  source = "./loadbalancing"
  security_groups = module.networking.security_group_out
  pub_subnetcidr = module.networking.pub_subnets_out
  tg_port = 8000
  tg_protocol = "HTTP"
  vpc_id = module.networking.vpc_id
  lb_healthy_threshold = 2
  lb_unhealthy_threshold = 2
  lb_timeout = 3
  lb_interval = 20
  listener_port = 80
  listener_protocol = "HTTP"
  
}

module "compute" {
  source = "./compute"
  instance_count = 2
  instance_type = "t3.micro"
  volume_size = 10
  public_subnet = module.networking.pub_subnets_out
  public_security = module.networking.security_group_out
  key_name = "key_pair_ec2"
  public_key_path = "~/.ssh/id_rsa.pub"
  user_data_path = "userdata.tpl"
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_endpoint = module.database.db_endpoint_out
  lb_target_group_arn = module.loadbalancing.lb_target_group_arn_out
  port_tg = 8000
}
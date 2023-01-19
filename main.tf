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
db_engine_version = "5.7.22"
db_instance_class = "db.t2.micro"
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
}
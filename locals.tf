# ROOT/locals.tf --------------------------------
locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {
  sg_access_from = ["0.0.0.0/0"]
}

locals {
  security_groups = {
    public = {
      name = "public_sgr"
      description = "Allow traffic"
      ingress = {
        ssh = {
          from_port = 22
          to_port = 22
          protocol = "tcp"
          cidr_blocks = local.sg_access_from
        }
        http = {
          from_port = 80
          to_port = 80
          protocol = "tcp"
          cidr_blocks = local.sg_access_from          
        }
        nginx = {
          from_port = 8000
          to_port = 8000
          protocol = "tcp"
          cidr_blocks = local.sg_access_from
        }
        https = {
          from_port = 443
          to_port = 443
          protocol = "tcp"
          cidr_blocks = local.sg_access_from           
        }
      }
    }
    rds = {
      name = "RDS_Ingress_Traffic"
      description = "Allow traffic for the RDS"
      ingress = {
        test_sql = {
          from_port = 3306
          to_port   = 3306
          protocol = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
      }
    }
  }
}
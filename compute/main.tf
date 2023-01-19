# ----------------------- COMPUTE/main.tf --------------------------- #

data "aws_ami" "ami" {
    most_recent = true
    owners = ["099720109477"]
    
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
    }
}

resource "random_id" "random" {
    byte_length = 2
    count = var.instance_count
}

resource "aws_instance" "ec2" {
    count = var.instance_count
    instance_type = var.instance_type
    ami = data.aws_ami.ami.id
    subnet_id = var.public_subnet[count.index]
    vpc_security_group_ids = [var.public_security]
    tags = {
        Name = "EC2-${random_id.random[count.index].id}"
    }
    
    root_block_device {
        volume_size = var.volume_size
    }
}   
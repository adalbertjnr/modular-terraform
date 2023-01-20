# ----------------------- COMPUTE/main.tf --------------------------- #

data "aws_ami" "ami" {
    most_recent = true
    owners = ["099720109477"]
    
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
}

resource "random_id" "random" {
    byte_length = 2
    count = var.instance_count
        keepers = {
        key_name = var.key_name
    }
}

resource "aws_key_pair" "key" {
    key_name = var.key_name
    public_key = file(var.public_key_path)
}

resource "aws_instance" "ec2" {
    count = var.instance_count
    instance_type = var.instance_type
    ami = data.aws_ami.ami.id
    subnet_id = var.public_subnet[count.index]
    vpc_security_group_ids = [var.public_security]
    key_name = aws_key_pair.key.id
    tags = {
        Name = "EC2-${random_id.random[count.index].id}"
    }
    user_data = templatefile(var.user_data_path, 
    {
        nodename = "EC2-${random_id.random[count.index].id}" 
        dbuser = var.db_username
        dbpass = var.db_password
        dbname = var.db_name
        db_endpoint = var.db_endpoint
    }
    )
    root_block_device {
        volume_size = var.volume_size
    }
} 

resource "aws_lb_target_group_attachment" "ec2_att" {
    count = var.instance_count
    target_group_arn = var.lb_target_group_arn
    target_id = aws_instance.ec2[count.index].id
    port = 8000
}
resource "aws_subnet" "redshift_private_subnet" {
    cidr_block = "172.19.44.0/24"
    vpc_id = var.vpc_id
    tags = {
        "Name" = "sn-dev-data-1a"
    }
}


resource "aws_subnet" "dms_private_subnet_1" {
    cidr_block = "172.19.46.0/24"
    vpc_id = var.vpc_id
    tags = {
        "Name" = "sn-dev-data-1c"
    }
}

resource "aws_subnet" "dms_private_subnet_2" {
    cidr_block = "172.19.44.0/24"
    vpc_id = var.vpc_id
    tags = {
        "Name" = "sn-dev-data-1a"
    }
}

resource "aws_subnet" "dms_private_subnet_3" {
    cidr_block = "172.19.45.0/24"
    vpc_id = var.vpc_id
    tags = {
        "Name" = "sn-dev-data-1b"
    }
}
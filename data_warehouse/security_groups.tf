
##Redshift Security Group 
resource "aws_security_group" "sg_dev_redshift_POC" {
    description = "Security group for Redsfhift POC"
    egress = [
        {
            cidr_blocks = [
                "0.0.0.0/0"
            ]
            description = ""
            from_port = 0
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "-1"
            security_groups = []
            self = false
            to_port = 0
        },
        {
            cidr_blocks = []
            description = ""
            from_port = 0
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "tcp"
            security_groups = []
            self = true
            to_port = 65535
        }
        
    ]
#    id = "sg-0a7453f3b44a921ae"

     ingress = [
        {
            cidr_blocks = [
                "172.19.44.53/32"
            ]
            description = "DMS Instance"
            from_port = 1962
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol = "tcp"
            security_groups  = []
            self = false
            to_port = 1962
        },
        {
            cidr_blocks = [
                "174.46.34.252/32",
                "68.208.80.137/32",
                "216.250.140.252/32",
                "172.16.0.0/12"
            ]
            description = ""
            from_port = 1962
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol = "tcp"
            security_groups  = []
            self = false
            to_port = 1962
        },
        {
            cidr_blocks = []
            description = ""
            from_port = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol = "tcp"
            security_groups  = []
            self = true
            to_port = 65535
        }
    ] 
    name = "sg_dev_redshift_POC"
    revoke_rules_on_delete = false
    vpc_id = var.vpc_id


}


##DMS Security Group
resource "aws_security_group" "dms-access-to-qa-onprem-db" {
    description = "security group for between DMS and SQL Server BIDBQA environment"
    egress = [
        {
            cidr_blocks = [
                "172.19.44.126/32"
            ]
            description = "Redshift Cluster"
            from_port = 1962
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "tcp"
            security_groups = []
            self = false
            to_port = 1962
        },
        {
            cidr_blocks = [
                "172.21.0.106/32"
            ]
            description = ""
            from_port = 1433
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "tcp"
            security_groups = []
            self = false
            to_port = 1433
        }
        
    ]
#    id = "sg-0017ca3022c82289d"

     ingress = [
        {
            cidr_blocks = [
                "172.21.0.106/32"
            ]
            description = ""
            from_port = 1433
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol = "tcp"
            security_groups  = []
            self = false
            to_port = 1433
        }
    ] 
    name = "dms-access-to-qa-onprem-db"
    vpc_id = var.vpc_id


}
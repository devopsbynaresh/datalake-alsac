###DMS Replication Subnet Group
resource "aws_dms_replication_subnet_group" "dms-subnet-group" {
  replication_subnet_group_description = "subnet group for DMS"
  replication_subnet_group_id  = "dms-subnet-group"
  subnet_ids = [ "subnet-08028120cbe0274fc",
  "subnet-013d2eda039a14bf5", "subnet-01ffafbd540cf34e9"
   ]

}


###Redshift Cluster Subnet Group
resource "aws_redshift_subnet_group" "redshift-private-subnet" {
    name = "redshift-private-subnet"
    description = "private redshift subnet"
    subnet_ids = [
  "subnet-01ffafbd540cf34e9"
   ]
  
}
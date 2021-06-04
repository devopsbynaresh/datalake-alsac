locals {
  common_tags = {
    Name           = ""
    Environment    = var.env
    CostCenter     = ""
    CreateBy       = "Terraform"
    CreateLocation = "https://bitbucket.alsac.stjude.org:8443/projects/ITSE/repos/slalom/browse/pii_buckets"
    Application    = ""
    ContactEmail   = ""
    CreateDate     = ""
    Compliance     = ""
  }
}

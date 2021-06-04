bucket         = "alsac-tfstate-disaster-recovery"
key            = "data-lake-disaster-recovery/infra-role.tfstate"
region         = "us-west-2" # Region the bucket is in
dynamodb_table = "alsac-tfstate-lock-disaster-recovery"
env            = "dr"
account_id     = "117183459779"

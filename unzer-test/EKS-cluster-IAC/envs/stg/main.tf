
terraform {
  backend "s3" {
    bucket = "terraform-remote-stg"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}


resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name         = var.dynamodb_table_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}

variable "terraform_owner_email" {
  description = "Email address of the ServiceAccount that has permissions to perform Terraform operations"
  type        = string
  # value should be obtained from environment variables only
}

module "stg_infra" {
  source                    = "../../blueprint"
  vpc_id                    = "vpc-123"
  region                    = "eu-west-1"
  cluster_name              = "stg-eks-cluster"
  subnets                   = ["subnet-1234", "subnet-1235", "subnet-1236"]
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  asg_desired_capacity      = 1
  asg_max_size              = 3
  asg_min_size              = 1
  instance_type             = "m4.large"
  spot_price                = "0.20"
  environment               = "stg"
}

module "infra_cycle" {
  source = "git::https://github.com/adembaransdv/terraform_cycle_examen.git//prod/cycle_module_prod"

  aws_access_key     =
  aws_secret_key     =
  aws_ami            = "ami-005fc0f236362e99f"
  aws_instance_type  = "t2.micro"
  aws_key_name       = "adem"
  instance_name_tag  = "ec2_adem_prod"
  aws_region         = "us-east-1"
  aws_key_pair       = "adem-key-prod"
  aws_security_group = "adem-sg-prod"
}

terraform {
  backend "s3" {
    bucket     = "adem-bucket"
    key        = "adem.tfstate-prod.tf"
    region     = "us-east-1"
    access_key =
    secret_key =
  }
}
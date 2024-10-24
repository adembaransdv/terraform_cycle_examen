module "infra_cycle" {
  source = "git::https://github.com/adembaransdv/terraform_cycle_examen.git//dev/cycle_module_dev"

  aws_access_key     =
  aws_secret_key     =
  aws_ami            = "ami-005fc0f236362e99f"
  aws_instance_type  = "t2.micro"
  aws_key_name       = "adem"
  instance_name_tag  = "ec2_adem_dev"
  aws_region         = "us-east-1"
}

terraform {
  backend "s3" {
    bucket     = "adem-bucket"
    key        = "adem.tfstate-dev.tf"
    region     = "us-east-1"
    access_key =
    secret_key =
  }
}
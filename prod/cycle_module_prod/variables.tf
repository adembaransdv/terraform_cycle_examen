variable "aws_access_key" {
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  sensitive   = true
}

variable "aws_ami" {
  type        = string
}

variable "aws_instance_type" {
  type        = string
}

variable "aws_key_name" {
  type        = string
}

variable "instance_name_tag" {
  type        = string
}

variable "aws_region" {
  type        = string
}

variable "aws_key_pair" {
  type        = string
}

variable "aws_security_group" {
  type        = string
}
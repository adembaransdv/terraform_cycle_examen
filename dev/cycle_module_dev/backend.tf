provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "adem-key-dev"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "adem" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.aws_instance_type
  key_name      = aws_key_pair.deployer_key.key_name

  tags = {
    Name = var.instance_name_tag
  }

  security_groups = [
    aws_security_group.allow_http_https.name
  ]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"                     # Utilisateur pour Amazon Linux
      host        = self.public_ip                 # IP publique de l'instance
      private_key = tls_private_key.ssh_key.private_key_openssh  # Clé privée SSH générée
    }

    inline = [
      "echo 'Connexion SSH réussie!'",
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo systemctl start nginx"
    ]
  }
}

resource "aws_security_group" "allow_http_https" {
  name        = "adem-sg-dev"
  description = "Allow HTTP, HTTPS, and SSH inbound traffic"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_eip" "ip" {
  instance = aws_instance.adem.id
  domain   = "vpc"
}

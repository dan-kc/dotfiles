terraform {
  backend "s3" {}
  required_version = ">= 1.10.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.3"
    }
  }
}

provider "aws" {
  region              = var.region
  allowed_account_ids = [var.account_id]
  default_tags {
    tags = { Project = "loft", ManagedBy = "OpenTofu" }
  }
}

variable "region" { type = string }
variable "account_id" { type = string }
data "sops_file" "loft" {
  source_file = "${path.module}/../../../secrets/loft.yaml"
}
variable "ami_id" {
  type = string
  validation {
    condition     = can(regex("^ami-[0-9a-f]+$", var.ami_id))
    error_message = "Use an official NixOS ARM image ID."
  }
}
variable "git_revision" {
  type = string
  validation {
    condition     = can(regex("^[0-9a-f]{40}$", var.git_revision))
    error_message = "Use a full, pushed Git commit SHA."
  }
}

data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "aws_vpc" "loft" {
  cidr_block           = "10.42.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "loft" }
}

resource "aws_subnet" "loft" {
  vpc_id            = aws_vpc.loft.id
  cidr_block        = "10.42.0.0/24"
  availability_zone = sort(data.aws_availability_zones.available.names)[0]
  tags              = { Name = "loft" }
}

resource "aws_internet_gateway" "loft" { vpc_id = aws_vpc.loft.id }
resource "aws_route_table" "loft" {
  vpc_id = aws_vpc.loft.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.loft.id
  }
}
resource "aws_route_table_association" "loft" {
  subnet_id      = aws_subnet.loft.id
  route_table_id = aws_route_table.loft.id
}

resource "aws_security_group" "loft" {
  name        = "loft-ssh"
  description = "Public key-only SSH; unrestricted outbound IPv4"
  vpc_id      = aws_vpc.loft.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "loft" {
  key_name_prefix = "loft-"
  public_key      = trimspace(data.sops_file.loft.data["ssh_public_key"])
  lifecycle { create_before_destroy = true }
}

resource "aws_instance" "loft" {
  # Validate publisher, architecture, release, and disk count before deployment.
  # Do not re-query this pinned AMI: upstream removes old images after 90 days, while
  # an existing instance must remain manageable after its image disappears.
  ami                         = var.ami_id
  instance_type               = "t4g.micro"
  subnet_id                   = aws_subnet.loft.id
  vpc_security_group_ids      = [aws_security_group.loft.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.loft.key_name
  user_data = templatefile("${path.module}/bootstrap.sh.tftpl", {
    revision = var.git_revision
  })
  credit_specification { cpu_credits = "standard" }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    encrypted             = true
    delete_on_termination = true
  }
  lifecycle {
    prevent_destroy = true
    # These are launch inputs. AWS reports public-IP association as true after
    # attaching the separately managed Elastic IP; that must not replace EC2.
    ignore_changes = [user_data, key_name, associate_public_ip_address]
  }
  depends_on = [aws_route_table_association.loft]
  tags       = { Name = "loft" }
}

resource "aws_eip" "loft" {
  domain = "vpc"
  tags   = { Name = "loft" }
}
resource "aws_eip_association" "loft" {
  instance_id   = aws_instance.loft.id
  allocation_id = aws_eip.loft.id
}

output "instance_id" { value = aws_instance.loft.id }
output "public_ip" { value = aws_eip.loft.public_ip }
output "ssh_command" { value = "ssh -i ~/.ssh/loft daniel@${aws_eip.loft.public_ip}" }

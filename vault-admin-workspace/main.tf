variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" { default = "us-east-2" }
variable "name" { default = "dynamic-aws-creds-vault-admin" }
variable "credential_type" { default = "iam_user" }

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "vault" {}

resource "vault_aws_secret_backend" "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
  path       = "${var.name}-path"

  default_lease_ttl_seconds = "120"
  max_lease_ttl_seconds     = "240"
}

resource "vault_aws_secret_backend_role" "admin" {
  name            = "${var.name}-role"
  backend         = vault_aws_secret_backend.aws.path
  credential_type = var.credential_type
  policy_document = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:*", "ec2:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
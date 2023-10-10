# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# provider "aws" {
#   region = var.region

#   default_tags {
#     tags = {
#       Hashicorp-Learn = "aws-iam-policy"
#     }
#   }

# }

resource "random_pet" "pet_name" {
  length    = 3
  separator = "-"
}

resource "aws_iam_user" "new_user" {
  name = "new_user"
  permissions_boundary = "arn:aws:iam::779388683117:policy/skygrp-mandatory-pb"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${random_pet.pet_name.id}-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


resource "aws_iam_policy" "policy" {
  name        = "${random_pet.pet_name.id}-policy"
  description = "My test policy"

  policy = data.aws_iam_policy_document.example.json
}

resource "aws_iam_user_policy_attachment" "attachment" {
  user       = aws_iam_user.new_user.name
  policy_arn = aws_iam_policy.policy.arn
}


data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
    effect = "Allow"
  }
  statement {
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.bucket.arn]
    effect = "Allow"
  }
}


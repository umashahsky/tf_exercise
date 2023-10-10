terraform {
  backend "s3" {
    bucket = "tf-exercise-bucket"
    key    = "exercise-state-file"
    region = "eu-west-2"
    shared_credentials_file = "~/.aws/credentials"
  }
}


provider "aws" {
  profile = "default"
  region  = "eu-west-2"
  shared_credentials_file = "~/.aws/credentials"
}     
terraform {
  backend "s3" {
    bucket         = "terraform-state-remote-backend-bucket"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform_state_remote-backend"
    encrypt        = true
  }
}

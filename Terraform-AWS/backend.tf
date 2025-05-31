terraform {
  backend "s3" {
    bucket         = "terraform-state-core-serve-app"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    use_lockfile   = true
    encrypt        = true
  }
}

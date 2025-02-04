module "vpc" {
  source     = "./modules/VPC"
  cidr_block = "10.0.0.0/16"
}

module "eks" {
  source     = "./modules/eks"
  public_subnets= module.vpc.public_subnets
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

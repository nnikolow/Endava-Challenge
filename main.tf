provider "aws" {
    region = var.region
}

module "vpc" {
  source = "./modules/vpc"
}


module "ec2" {
  source               = "./modules/ec2"
  vpc                  = module.vpc.vpc_id
  subnet_id            = module.vpc.public_subnet_ids
  alb_target_group_arn = module.alb.alb_target_group_arn
}


module "alb" {
  source              = "./modules/alb"
  vpc                 = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnet_ids
}

module "rds" {
  source             = "./modules/rds"
  db_subnet          = module.vpc.private_subnet_id
  db_username        = var.db_username
  db_password        = var.db_password
  vpc                = module.vpc.vpc_id
  ec2_security_group = module.ec2.ec2_security_group
}
module "vpc" {
  source  = "./modules/vpc"
  version = "1.0.0"
}

module "subnet" {
  source  = "./modules/subnet"
  version = "1.0.0"
  vpc_id  = module.vpc.vpc_id
}

module "igw" {
  source  = "./modules/igw"
  version = "1.0.0"
  vpc_id  = module.vpc.vpc_id
}

module "route_table" {
  source   = "./modules/route-table"
  version  = "1.0.0"
  vpc_id   = module.vpc.vpc_id
  igw_id   = module.igw.igw_id
  subnet_id = module.subnet.subnet_id
}

module "security_group" {
  source  = "./modules/security-group"
  version = "1.0.0"
  vpc_id  = module.vpc.vpc_id
}

module "keypair" {
  source  = "./modules/keypair"
  version = "1.0.0"
}

module "ec2" {
  source    = "./modules/ec2"
  version   = "1.0.0"
  subnet_id = module.subnet.subnet_id
  sg_id     = module.security_group.sg_id
  key_name  = module.keypair.key_name
}

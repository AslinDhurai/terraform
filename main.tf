module "vpc" {
  source = "./modules/vpc"
}

module "subnet" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id
}

module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source = "./modules/route-table"
  vpc_id = module.vpc.vpc_id
  igw_id = module.igw.igw_id
  subnet_id = module.subnet.subnet_id
}

module "security_group" {
  source = "./modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "keypair" {
  source = "./modules/keypair"
}

module "ec2" {
  source   = "./modules/ec2"
  subnet_id = module.subnet.subnet_id
  sg_id     = module.security_group.sg_id
  key_name  = module.keypair.key_name
}

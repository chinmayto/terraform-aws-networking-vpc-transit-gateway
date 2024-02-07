####################################################
# Create two VPC and components
####################################################

module "vpc_a" {
  source               = "./modules/vpc"
  name                 = "VPC-A"
  aws_region           = var.aws_region
  vpc_cidr_block       = var.vpc_cidr_block_a #"10.1.0.0/16"
  public_subnets_cidrs = [cidrsubnet(var.vpc_cidr_block_a, 8, 1)]
  enable_dns_hostnames = var.enable_dns_hostnames
  aws_azs              = var.aws_azs
  common_tags          = local.common_tags
  naming_prefix        = local.naming_prefix
}


module "vpc_b" {
  source               = "./modules/vpc"
  name                 = "VPC-B"
  aws_region           = var.aws_region
  vpc_cidr_block       = var.vpc_cidr_block_b #"10.2.0.0/16"
  public_subnets_cidrs = [cidrsubnet(var.vpc_cidr_block_b, 8, 1)]
  enable_dns_hostnames = var.enable_dns_hostnames
  aws_azs              = var.aws_azs
  common_tags          = local.common_tags
  naming_prefix        = local.naming_prefix
}

module "vpc_c" {
  source               = "./modules/vpc"
  name                 = "VPC-C"
  aws_region           = var.aws_region
  vpc_cidr_block       = var.vpc_cidr_block_c #"10.3.0.0/16"
  public_subnets_cidrs = [cidrsubnet(var.vpc_cidr_block_c, 8, 1)]
  enable_dns_hostnames = var.enable_dns_hostnames
  aws_azs              = var.aws_azs
  common_tags          = local.common_tags
  naming_prefix        = local.naming_prefix
}

####################################################
# Create EC2 Server Instances
####################################################

module "vpc_a_public_host" {
  source        = "./modules/web"
  instance_type = var.instance_type
  instance_key  = var.instance_key
  subnet_id     = module.vpc_a.public_subnets[0]
  vpc_id        = module.vpc_a.vpc_id
  ec2_name      = "Public Host A"
  common_tags   = local.common_tags
  naming_prefix = local.naming_prefix
}

module "vpc_b_public_host" {
  source        = "./modules/web"
  instance_type = var.instance_type
  instance_key  = var.instance_key
  subnet_id     = module.vpc_b.public_subnets[0]
  vpc_id        = module.vpc_b.vpc_id
  ec2_name      = "Public Host B"
  common_tags   = local.common_tags
  naming_prefix = local.naming_prefix
}


module "vpc_c_public_host" {
  source        = "./modules/web"
  instance_type = var.instance_type
  instance_key  = var.instance_key
  subnet_id     = module.vpc_c.public_subnets[0]
  vpc_id        = module.vpc_c.vpc_id
  ec2_name      = "Public Host C"
  common_tags   = local.common_tags
  naming_prefix = local.naming_prefix
}

####################################################
# Create Transit Gateway and attachments
####################################################

module "transit_gateway" {
  source                 = "./modules/transit-gw"
  vpc_ids                = [module.vpc_c.vpc_id, module.vpc_b.vpc_id, module.vpc_a.vpc_id]
  subnet_ids             = [module.vpc_c.public_subnets[0], module.vpc_b.public_subnets[0], module.vpc_a.public_subnets[0]]
  common_tags            = local.common_tags
  naming_prefix          = local.naming_prefix
  route_table_ids        = [module.vpc_a.public_route_table_id, module.vpc_b.public_route_table_id, module.vpc_c.public_route_table_id]
  destination_cidr_block = "10.0.0.0/8"
}

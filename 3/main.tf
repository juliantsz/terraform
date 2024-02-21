module "dev_vpc" {
    source = "../modules/vpc"
    //source = "git::ssh://git@gitlab.com/route/to-repo.git//route/to/file?ref=master"

    environment           = var.dev_environment
    vpc_cidr_block        = var.vpc_cidr_block
    azs                   = var.azs
    public_subnets_cidrs  = var.public_subnets_cidrs
    private_subnets_cidrs = var.private_subnets_cidrs
}

module "stg_vpc" {
    source = "../modules/vpc"
    //source = "git::ssh://git@gitlab.com/route/to-repo.git//route/to/file?ref=master"

    environment           = var.stg_environment
    vpc_cidr_block        = var.vpc_cidr_block
    azs                   = var.azs
    public_subnets_cidrs  = var.public_subnets_cidrs
    private_subnets_cidrs = var.private_subnets_cidrs
}
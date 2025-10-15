data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" default  {
  default = true
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "dev"
  cidr = "10.0.0.0/16"

  azs             = ["eu-east-1a", "eu-east-1b", "eu-east1c"]
 
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]


  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "blog" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t3.nano"
  vpc_security_group_ids = [module.blog_sg.secuirty_group_id]
  subnet_id = module.blog_vpc.public_subnets[0]

  tags = {
    Name = "HelloWorld"
  }
module "blog_sg"
  source ="terraform-aws-modules/secuirty_group/aws"
  version = "4.13.0"

  vpc_id = module.blog_vpc.vpc_id
  name = "blog"
  ingree_rules = ["https-443-tcp","http-80-tpc"]
  ingress_cidr_blocks = ["0.0.0.0/0]
  egress_rules = ["all-all]
  egress_cidr_blocks = ["0.0.0.0/0]

}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  name    = "gorilla-vpc"
  cidr    = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

  enable_dns_hostnames          = true
  enable_nat_gateway            = true
  single_nat_gateway            = true
  manage_default_network_acl    = true
  public_dedicated_network_acl  = true
  private_dedicated_network_acl = true
  private_inbound_acl_rules = [{ "cidr_block" : "10.0.0.0/16", "from_port" : 0, "protocol" : "-1", "rule_action" : "allow", "rule_number" : 100, "to_port" : 0 },
  { "cidr_block" : "0.0.0.0/0", "from_port" : 1024, "protocol" : "tcp", "rule_action" : "allow", "rule_number" : 200, "to_port" : 65535 }]
}

resource "aws_security_group" "vpcendpoint_sg" {
  name        = "vpcendpoint-sg"
  description = "SG for VPC endpoint usage"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "vpcendpoint-sg"
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "SG for beanstalk app"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 1024
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  ingress {
    from_port   = 123
    to_port     = 123
    protocol    = "UDP"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "app-sg"
  }
}

resource "aws_vpc_endpoint" "cloudformation" {
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnets
  service_name        = "com.amazonaws.us-west-2.cloudformation"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpcendpoint_sg.id]
  private_dns_enabled = true
  tags = {
    Name = "Cloudformation-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr" {
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnets
  service_name        = "com.amazonaws.us-west-2.ecr.api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpcendpoint_sg.id]
  private_dns_enabled = true
  tags = {
    Name = "ecr-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnets
  service_name        = "com.amazonaws.us-west-2.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpcendpoint_sg.id]
  private_dns_enabled = true
  tags = {
    Name = "ecr-dkr-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "elasticbeanstalk" {
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnets
  service_name        = "com.amazonaws.us-west-2.elasticbeanstalk"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpcendpoint_sg.id]
  private_dns_enabled = true
  tags = {
    Name = "elasticbeanstalk-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "elasticbeanstalk_health" {
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnets
  service_name        = "com.amazonaws.us-west-2.elasticbeanstalk-health"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpcendpoint_sg.id]
  private_dns_enabled = true
  tags = {
    Name = "elasticbeanstalk-health-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets
  service_name       = "com.amazonaws.us-west-2.s3"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.vpcendpoint_sg.id]
  tags = {
    Name = "s3-interface-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "sqs" {
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnets
  service_name        = "com.amazonaws.us-west-2.sqs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpcendpoint_sg.id]
  private_dns_enabled = true
  tags = {
    Name = "sqs-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.us-west-2.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.vpc.private_route_table_ids
  tags = {
    Name = "s3-gateway-vpc-endpoint"
  }
}
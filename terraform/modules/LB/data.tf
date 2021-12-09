data "aws_vpc" "vpc" {
  default = true
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id
}
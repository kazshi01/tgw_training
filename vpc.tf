data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["default-vpc"]
  }
}

data "aws_subnet" "default" {
  filter {
    name   = "tag:Name"
    values = ["default-private-a"]
  }
}

data "aws_route_table" "default" {
  subnet_id = data.aws_subnet.default.id
}

resource "aws_route" "to_project" {
  route_table_id         = data.aws_route_table.default.id
  destination_cidr_block = "10.0.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.example.id
}

data "aws_vpc" "project" {
  filter {
    name   = "tag:Name"
    values = ["プロジェクト-vpc"]
  }
}

data "aws_subnet" "project" {
  filter {
    name   = "tag:Name"
    values = ["プロジェクト-subnet-private1-ap-northeast-1a"]
  }
}

data "aws_route_table" "project" {
  subnet_id = data.aws_subnet.project.id
}

resource "aws_route" "to_default" {
  route_table_id         = data.aws_route_table.project.id
  destination_cidr_block = "172.31.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.example.id
}

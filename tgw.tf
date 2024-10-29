resource "aws_ec2_transit_gateway" "example" {
  description = "Example Transit Gateway"
  amazon_side_asn = 64512
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support = "enable"
  vpn_ecmp_support = "enable"
  tags = {
    Name = "example-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "default" {
  subnet_ids         = [data.aws_subnet.default.id]
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = data.aws_vpc.default.id

  tags = {
    Name = "default-tgw-attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "project" {
  subnet_ids         = [data.aws_subnet.project.id]
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = data.aws_vpc.project.id

  tags = {
    Name = "project-tgw-attachment"
  }
}

resource "aws_ec2_transit_gateway_route_table" "example" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id

  tags = {
    Name = "example-tgw-route-table"
  }
}

## TGWルート

resource "aws_ec2_transit_gateway_route" "default" {
  destination_cidr_block         = "172.31.0.0/16"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.default.id
}

resource "aws_ec2_transit_gateway_route" "project" {
  destination_cidr_block         = "10.0.0.0/16"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.project.id
}

## ルートテーブルの関連付け

resource "aws_ec2_transit_gateway_route_table_association" "default_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.default.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
}

resource "aws_ec2_transit_gateway_route_table_association" "project_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.project.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
}

## ルートテーブルの伝播

resource "aws_ec2_transit_gateway_route_table_propagation" "default_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.default.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "project_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.project.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
}

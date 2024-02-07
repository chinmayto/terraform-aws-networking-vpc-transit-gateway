####################################################
# Create the Transit gateway
####################################################

resource "aws_ec2_transit_gateway" "transit_gateway" {
  description                     = "Transit Gateway"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = merge(var.common_tags, {
    Name = "${var.naming_prefix}-transitgw"
  })
}

####################################################
# Create the VPC attachments
####################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-attach" {
  count              = length(var.vpc_ids)
  transit_gateway_id = aws_ec2_transit_gateway.transit_gateway.id
  vpc_id             = var.vpc_ids[count.index]
  subnet_ids         = [var.subnet_ids[count.index]]
}

####################################################
# Create the Transit Gateway Routes in each VPCs route table
####################################################
resource "aws_route" "tw_route" {
  count                  = length(var.route_table_ids)
  route_table_id         = var.route_table_ids[count.index]
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_ec2_transit_gateway.transit_gateway.id
  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.tgw-attach
  ]
}
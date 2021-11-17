provider "aws" {
  region = "us-west-2"
}

data "aws_availability_zones" "available" {
}

resource "aws_vpc" "IEvpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "IEvpc"
  }
}

resource "aws_internet_gateway" "IEgw" {
  vpc_id = "${aws_vpc.IEvpc.id}"

  tags = {
    Name = "IEgw"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.IEvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IEgw.id}"
  }

  tags = {
    Name = "IEPubRouteTab"
  }
}

resource "aws_default_route_table" "private_route" {
  default_route_table_id = "${aws_vpc.IEvpc.default_route_table_id}"

  tags = {
    Name = "IEPrivRouteTab"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = "${length(var.public_cidrs)}"
  cidr_block              = "${var.public_cidrs[count.index]}"
  vpc_id                  = "${aws_vpc.IEvpc.id}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "IEPubSubnet.${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = "${length(var.private_cidrs)}"
  cidr_block        = "${var.private_cidrs[count.index]}"
  vpc_id            = "${aws_vpc.IEvpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "IEPrivSubnet.${count.index + 1}"
  }
}

resource "aws_route_table_association" "public_subnet_ass" {
  count          = "${length(var.public_cidrs)}"
  route_table_id = "${aws_route_table.public_route.id}"
  subnet_id      = "${aws_subnet.public_subnet.*.id[count.index]}"
  depends_on     = [aws_route_table.public_route, aws_subnet.public_subnet]
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_subnet_ass" {
  count          = "${length(var.private_cidrs)}"
  route_table_id = "${aws_default_route_table.private_route.id}"
  subnet_id      = "${aws_subnet.private_subnet.*.id[count.index]}"
  depends_on     = [aws_default_route_table.private_route, aws_subnet.private_subnet]
}

resource "aws_security_group" "IEsg" {
  name   = "IEsg"
  vpc_id = "${aws_vpc.IEvpc.id}"
}

resource "aws_security_group_rule" "ssh_inbound_access" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.IEsg.id}"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http_inbound_access" {
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  security_group_id = "${aws_security_group.IEsg.id}"
}

resource "aws_security_group_rule" "all_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.IEsg.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "upnp_inbound_access" {
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  security_group_id = "${aws_security_group.IEsg.id}"
}

resource "aws_security_group_rule" "grafana_inbound_access" {
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  security_group_id = "${aws_security_group.IEsg.id}"
}

resource "aws_security_group_rule" "node_exporter_inbound_access" {
  from_port         = 9100
  to_port           = 9100
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  security_group_id = "${aws_security_group.IEsg.id}"
}

resource "aws_security_group_rule" "prometheus_inbound_access" {
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  security_group_id = "${aws_security_group.IEsg.id}"
}

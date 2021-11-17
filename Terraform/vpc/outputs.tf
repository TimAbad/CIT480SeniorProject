output "aws_vpc_id" {
	value = "${aws_vpc.IEvpc.id}"
}

output "aws_internet_gateway" {
	value = "${aws_internet_gateway.IEgw.id}"
}

output "security_group" {
	value = "${aws_security_group.IEsg.id}"
}

output "subnets" {
	value = "${aws_subnet.public_subnet.*.id}"
}

output "aws_vpc_id" {
	value = "${aws_vpc.IEvpc.id}"
}

output "aws_internet_gateway" {
	value = "${aws_internet_gateway.IEgw.id}"
}

/* output "security_group" {
	value = "${aws_security_group.IEsg.id}"
}
*/
output "public_subnets" {
	value = "${aws_subnet.public_subnet.*.id}"
}

output "subnet1" {
  value = "${element(aws_subnet.public_subnet.*.id, 1 )}"
}

output "subnet2" {
  value = "${element(aws_subnet.public_subnet.*.id, 2 )}"
}

output "private_subnet1" {
  value = "${element(aws_subnet.private_subnet.*.id, 1 )}"
}

output "private_subnet2" {
  value = "${element(aws_subnet.private_subnet.*.id, 2 )}"
}

output "ec2_global_ips" {
value = "${ data.aws_instances.nodes.public_ips }"
}

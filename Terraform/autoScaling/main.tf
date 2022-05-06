provider "aws" {
  region = "us-west-2"
}
data "aws_availability_zones" "available" {}

resource "aws_key_pair" "IE_auto_keys" {
        key_name = "IE-auto-keys"
        public_key = "${file(var.my_public_key)}"

}
resource "aws_launch_configuration" "IE-launch-config" {
  image_id        = "ami-036d46416a34a611c"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.IE-autoscale-sg.id}"]
  key_name               = "${aws_key_pair.IE_auto_keys.id}"
  user_data = <<-EOF
              #!/bin/bash
              apt update && apt install ansible -y
              mkdir /home/test
              cd /home/test
              git clone https://github.com/TimAbad/CIT480SeniorProject.git
              ansible-playbook -i localhost /home/test/CIT480SeniorProject/Monitoring_WithAlerts/deploy_app.yml
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "IE-autoscale-group" {
  launch_configuration = aws_launch_configuration.IE-launch-config.name
  vpc_zone_identifier  = ["${var.subnet1}", "${var.subnet2}"]

  target_group_arns = ["${var.target_group_arn}"]
  health_check_type = "ELB"

  health_check_grace_period = 10800
  min_size = 2
  max_size = 4
  desired_capacity = 2
  max_instance_lifetime = 86400
  protect_from_scale_in = true

  tag {
    key                 = "Name"
    value               = "IE-autoscale-group"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "IE-autoscale-sg" {
  name   = "IE-autoscale-sg"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "ssh_inbound_access" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.IE-autoscale-sg.id
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
  security_group_id = aws_security_group.IE-autoscale-sg.id
}

resource "aws_security_group_rule" "https_inbound_access" {
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  security_group_id = aws_security_group.IE-autoscale-sg.id
}

resource "aws_security_group_rule" "all_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.IE-autoscale-sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "upnp_inbound_access" {
  from_port         = 8501
  to_port           = 8501
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  security_group_id = aws_security_group.IE-autoscale-sg.id
}

resource "aws_security_group_rule" "grafana_inbound_access" {
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  security_group_id = aws_security_group.IE-autoscale-sg.id
}

resource "aws_security_group_rule" "node_exporter_inbound_access" {
  from_port         = 9100
  to_port           = 9100
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  security_group_id = aws_security_group.IE-autoscale-sg.id
}

resource "aws_security_group_rule" "prometheus_inbound_access" {
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  security_group_id = aws_security_group.IE-autoscale-sg.id
}

data "aws_instances" "nodes" {
  depends_on = [ aws_autoscaling_group.IE-autoscale-group ]
}

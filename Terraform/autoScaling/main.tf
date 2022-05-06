provider "aws" {
	region = "us-west-2"
}

resource "aws_lb_target_group" "IE_target_group" {
	health_check {
		interval = 300
		path = "/"
		protocol = "HTTP"
		timeout = 120
		healthy_threshold = 2
		unhealthy_threshold = 10
		
	}
	name = "IE-tg-1"
	port = 80
	protocol = "HTTP"
	target_type = "instance"
	vpc_id = "${var.vpc_id}"
}

/* resource "aws_lb_target_group_attachment" "IE_tg_attach1" {
	target_group_arn = "${aws_lb_target_group.IE_target_group.arn}"
	target_id = "${var.instance1_id}"
	port = 80

}

resource "aws_lb_target_group_attachment" "IE_tg_attach2" {
        target_group_arn = "${aws_lb_target_group.IE_target_group.arn}"
        target_id = "${var.instance2_id}"
        port = 80

}
*/
resource "aws_lb" "IE_aws_alb" {
	name = "IE-alb"
	internal = false
	
	security_groups = [
		"${aws_security_group.IE_alb_sg.id}",
]

	subnets = [
		"${var.subnet1}",
		"${var.subnet2}",
]

	tags = {
		name = "IE-alb"
	}

	ip_address_type = "ipv4"
	load_balancer_type = "application"
}

resource "aws_lb_listener" "IE_alb_listener" {
	load_balancer_arn = "${aws_lb.IE_aws_alb.arn}"
	port = 80
	protocol = "HTTP"

	default_action {
		type = "forward"
		target_group_arn = "${aws_lb_target_group.IE_target_group.arn}"
	}
}

resource "aws_security_group" "IE_alb_sg" {
	name = "IE-alb-sg"
	vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "inbound_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.IE_alb_sg.id}"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_https" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.IE_alb_sg.id}"
  to_port           = 443
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.IE_alb_sg.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

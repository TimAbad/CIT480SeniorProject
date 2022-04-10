resource "aws_route53_zone" "my-ie-zone" {
  name = "internetexplorers.space"
/*  vpc {
    vpc_id = "${var.vpc_id}"
  } */
}

resource "aws_route53_record" "www" { 
  name = "www.internetexplorers.space" 
  zone_id = "${aws_route53_zone.my-ie-zone.id}"
  type = "A"
  records = "${var.arecord}"
  ttl = "25"
}



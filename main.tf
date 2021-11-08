/*
AMI
Instance Type t2.micro
VPC --> default
Tags -->
Security Group -->
key_pair -->
*/
resource "aws_key_pair" "examplekp" {
  key_name   = "my-example-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOJ7oS3ZWuhezqOdBtOBbHcoBnc6dQziOohyo7wX8PH+KhjKHt3nMMNw3OgPqcIWE3TevpaM6ZBicIy3ps5HD8bQJhDTKtre+dqeR9KhM7lgbnmy+V56GXK8vLrwL3vJVFL+8bYICybARBO48oJWc3l5B+yWXITl2YncC8q2jt9g/xoYutgns83xvDu8d1JUtFLDEZ/zlG1H/9Xqwddw5Y2yvigFLc6B0vEn2aHcVXUCgFaSvKBem3HnWn3e5soLBJBlHg22lHKj+KoTT60wQ9VqzPnqgy0VqKrmqwQT/oKVRdKNuhVH868o8Hcf1Rl4j/qZV/clEHVGgxzBrRWkmP root@ecc94da42340"
}

resource "aws_security_group" "examplesg" {
  name        = "my-example-sg"
  description = "Allow ssh traffic"



        ingress {
                from_port   = 22
                to_port     = 22
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

        egress  {
                from_port   = 0
                to_port     = 0
                protocol    = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }
}
resource "aws_instance" "ec2_instance" {
  ami                    = "ami-020db2c14939a8efb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.examplesg.id}"]
  key_name               = "${aws_key_pair.examplekp.id}"
tags = {
    name = "my-first-ec2-instance"
  }
  subnet_id = "subnet-0ebf68f57fe44354b"
}

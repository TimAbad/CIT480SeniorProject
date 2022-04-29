provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_user" "ieuser" {
	count = "${length(var.username)}"
	name = "${element(var.username, count.index)}"
}

data "aws_iam_policy_document" "iepoldoc" {
	statement {
		actions = [ 
			"ec2:Describe*" ]
		resources = [
			"*" ]
	}
}


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

resource "aws_iam_policy" "iepolicy" {
	name = "ec2-read-only"
	policy = "${data.aws_iam_policy_document.iepoldoc.json}"
}

resource "aws_iam_user_policy_attachment" "iepolicy-attach" {
	count = "${length(var.username)}"
	user = "${element(aws_iam_user.ieuser.*.name, count.index)}"
	policy_arn = "${aws_iam_policy.iepolicy.arn}"
}

resource "aws_iam_user_login_profile" "ieprofile" {
	count = "${length(var.username)}"
        user = "${element(aws_iam_user.ieuser.*.name, count.index)}"
	password_reset_required = true
	pgp_key = "keybase:cit481"
}

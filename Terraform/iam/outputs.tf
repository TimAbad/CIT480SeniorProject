output "ku_user_arn" {
	value = "${aws_iam_user.ieuser.0.arn}"
}

output "ta_user_arn" {
        value = "${aws_iam_user.ieuser.1.arn}"
}

output "kt_user_arn" {
        value = "${aws_iam_user.ieuser.2.arn}"
}

output "cr_user_arn" {
        value = "${aws_iam_user.ieuser.3.arn}"
}

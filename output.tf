output "lambda_arn" {
  value = "${coalesce(join(",", aws_lambda_function.function.*.arn), join(",", aws_lambda_function.function_vpc.*.arn))}"
}

output "role_arn" {
  value = "${aws_iam_role.lambda.arn}"
}

output "role_name" {
  value = "${aws_iam_role.lambda.name}"
}

output "lambda_arn" {
  value = "${coalesce(join(",", aws_lambda_function.function.*.arn), join(",", aws_lambda_function.function_vpc.*.arn))}"
}

output "role_arn" {
  value = "${aws_iam_role.lambda.arn}"
}

output "role_name" {
  value = "${aws_iam_role.lambda.name}"
}

output "qualified_arn" {
  value = "${coalesce(join(",", aws_lambda_function.function.*.qualified_arn), join(",", aws_lambda_function.function_vpc.*.qualified_arn))}"
}

output "invoke_arn" {
  value = "${coalesce(join(",", aws_lambda_function.function.*.invoke_arn), join(",", aws_lambda_function.function_vpc.*.invoke_arn))}"
}

output "version" {
  value = "${coalesce(join(",", aws_lambda_function.function.*.version), join(",", aws_lambda_function.function_vpc.*.version))}"
}

output "last_modified" {
  value = "${coalesce(join(",", aws_lambda_function.function.*.last_modified), join(",", aws_lambda_function.function_vpc.*.last_modified))}"
}

output "kms_key_arn" {
  value = "${coalesce(join(",", aws_lambda_function.function.*.kms_key_arn), join(",", aws_lambda_function.function_vpc.*.kms_key_arn))}"
}

output "source_code_hash" {
  value = "${coalesce(join(",", aws_lambda_function.function.*.source_code_hash), join(",", aws_lambda_function.function_vpc.*.source_code_hash))}"
}

output "source_code_size" {
  value = "${coalesce(join(",", aws_lambda_function.function.*.source_code_size), join(",", aws_lambda_function.function_vpc.*.source_code_size))}"
}

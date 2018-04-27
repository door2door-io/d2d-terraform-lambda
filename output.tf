output "lambda_arn" {
  value = "${coalesce(
    join(",", aws_lambda_function.function.*.arn),
    join(",", aws_lambda_function.function_vpc.*.arn),
    join(",", aws_lambda_function.function_noenv.*.arn),
    join(",", aws_lambda_function.function_vpc_noenv.*.arn)
  )}"
}

output "role_arn" {
  value = "${aws_iam_role.lambda.arn}"
}

output "role_name" {
  value = "${aws_iam_role.lambda.name}"
}

output "qualified_arn" {
  value = "${coalesce(
    join(",", aws_lambda_function.function.*.qualified_arn),
    join(",", aws_lambda_function.function_vpc.*.qualified_arn),
    join(",", aws_lambda_function.function_noenv.*.qualified_arn),
    join(",", aws_lambda_function.function_vpc_noenv.*.qualified_arn)
  )}"
}

output "invoke_arn" {
  value = "${coalesce(
    join(",", aws_lambda_function.function.*.invoke_arn),
    join(",", aws_lambda_function.function_vpc.*.invoke_arn),
    join(",", aws_lambda_function.function_noenv.*.invoke_arn),
    join(",", aws_lambda_function.function_vpc_noenv.*.invoke_arn)
  )}"
}

output "version" {
  value = "${coalesce(
    join(",", aws_lambda_function.function.*.version),
    join(",", aws_lambda_function.function_vpc.*.version),
    join(",", aws_lambda_function.function_noenv.*.version),
    join(",", aws_lambda_function.function_vpc_noenv.*.version)
  )}"
}

output "last_modified" {
  value = "${coalesce(
    join(",", aws_lambda_function.function.*.last_modified),
    join(",", aws_lambda_function.function_vpc.*.last_modified),
    join(",", aws_lambda_function.function_noenv.*.last_modified),
    join(",", aws_lambda_function.function_vpc_noenv.*.last_modified)
  )}"
}

output "source_code_hash" {
  value = "${coalesce(
    join(",", aws_lambda_function.function.*.source_code_hash),
    join(",", aws_lambda_function.function_vpc.*.source_code_hash),
    join(",", aws_lambda_function.function_noenv.*.source_code_hash),
    join(",", aws_lambda_function.function_vpc_noenv.*.source_code_hash)
  )}"
}

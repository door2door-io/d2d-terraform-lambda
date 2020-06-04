###############################################################################
# non-VPC Lambda

resource "aws_lambda_function" "function" {
  count            = "${var.count == 1 && length(var.subnet_ids) == 0 && length(var.env_variables) > 0 ? 1 : 0}"
  function_name    = "${var.function_name}"
  description      = "${var.description}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "${var.handler}"
  runtime          = "${local.runtime}"
  timeout          = "${var.timeout}"
  memory_size      = "${var.memory_size}"
  filename         = "${local.deploy_archive_file}"
  source_code_hash = "${local.deploy_archive_hash}"
  environment      = { variables = "${var.env_variables}" }
  publish          = "${var.publish}"
  tags             = "${merge(var.tags, map("Name", var.function_name))}"
  lifecycle {
    # Avoid triggering code updates when temp path changes
    # because of different Terraform execution environments
    ignore_changes = ["filename"]
  }
}


###############################################################################
# VPC Lambda

resource "aws_lambda_function" "function_vpc" {
  count            = "${var.count == 1 && length(var.subnet_ids) != 0 && length(var.env_variables) > 0 ? 1 : 0}"
  function_name    = "${var.function_name}"
  description      = "${var.description}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "${var.handler}"
  runtime          = "${local.runtime}"
  timeout          = "${var.timeout}"
  memory_size      = "${var.memory_size}"
  filename         = "${local.deploy_archive_file}"
  source_code_hash = "${local.deploy_archive_hash}"
  environment      = { variables = "${var.env_variables}" }
  publish          = "${var.publish}"
  tags             = "${merge(var.tags, map("Name", var.function_name))}"
  vpc_config {
    subnet_ids         = ["${var.subnet_ids}"]
    security_group_ids = ["${var.security_group_ids}"]
  }
  lifecycle {
    # Avoid triggering code updates when temp path changes
    # because of different Terraform execution environments
    ignore_changes = ["filename"]
  }
}


###############################################################################
# non-VPC Lambda / empty environment

resource "aws_lambda_function" "function_noenv" {
  count            = "${var.count == 1 && length(var.subnet_ids) == 0 && length(var.env_variables) == 0 ? 1 : 0}"
  function_name    = "${var.function_name}"
  description      = "${var.description}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "${var.handler}"
  runtime          = "${local.runtime}"
  timeout          = "${var.timeout}"
  memory_size      = "${var.memory_size}"
  filename         = "${local.deploy_archive_file}"
  source_code_hash = "${local.deploy_archive_hash}"
  publish          = "${var.publish}"
  tags             = "${merge(var.tags, map("Name", var.function_name))}"
  lifecycle {
    # Avoid triggering code updates when temp path changes
    # because of different Terraform execution environments
    ignore_changes = ["filename"]
  }
}


###############################################################################
# VPC Lambda / empty environment

resource "aws_lambda_function" "function_vpc_noenv" {
  count            = "${var.count == 1 && length(var.subnet_ids) != 0 && length(var.env_variables) == 0 ? 1 : 0}"
  function_name    = "${var.function_name}"
  description      = "${var.description}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "${var.handler}"
  runtime          = "${local.runtime}"
  timeout          = "${var.timeout}"
  memory_size      = "${var.memory_size}"
  filename         = "${local.deploy_archive_file}"
  source_code_hash = "${local.deploy_archive_hash}"
  publish          = "${var.publish}"
  tags             = "${merge(var.tags, map("Name", var.function_name))}"
  vpc_config {
    subnet_ids         = ["${var.subnet_ids}"]
    security_group_ids = ["${var.security_group_ids}"]
  }
  lifecycle {
    # Avoid triggering code updates when temp path changes
    # because of different Terraform execution environments
    ignore_changes = ["filename"]
  }
}

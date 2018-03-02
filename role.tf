data "aws_iam_policy_document" "lambda_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${local.aws_iam_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_service_role" {
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${local.lambda_service_role}"
}

resource "aws_iam_role_policy_attachment" "lambda_attach_policies" {
  count      = "${local.attach_policies_count}"
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${var.attach_policies[count.index]}"
}

resource "aws_iam_role_policy" "lambda_inline_policies" {
  count  = "${local.inline_policies_count}"
  role   = "${aws_iam_role.lambda.name}"
  policy = "${var.inline_policies[count.index]}"
}

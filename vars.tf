###############################################################################
# Mandatory input variables

variable "function_name" {
  type        = string
  description = "Lambda function name"
}

variable "runtime" {
  type        = string
  description = "Lambda function runtime"
}

variable "handler" {
  type        = string
  description = "Name of the function that Lambda will call to start running"
}

###############################################################################
# Optional input variables

variable "source_code_path" {
  type        = string
  description = "Path to function's source code to manage deployment"
  default     = ""
}

variable "description" {
  type        = string
  description = "Lambda function description"
  default     = "A Lambda function managed by Terraform"
}

variable "timeout" {
  type        = string
  description = "Function execution time in seconds after which Lambda terminates the function"
  default     = "10"
}

variable "memory_size" {
  type        = string
  description = "Amount of memory in MB allocated to the Lambda function"
  default     = "128"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to run the Lambda in the private VPC they belong to"
  default     = []
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach to the Lambda"
  default     = []
}

variable "env_variables" {
  type        = map(string)
  description = "Map of environment variables passed to Lambda function"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to add to the Lambda"
  default     = {}
}

variable "attach_policies" {
  type        = list(string)
  description = "List of IAM policies to attach to the Lambda role"
  default     = []
}

variable "inline_policies" {
  type        = list(string)
  description = "List of inline json policy documents to include in the Lambda role"
  default     = []
}

variable "publish" {
  type        = string
  description = "Whether to publish creation/change as new Lambda Function Version"
  default     = true
}

###############################################################################
# Internal variables

variable "supported_runtimes" {
  type        = list(string)
  description = "List of supported runtimes, used to validate input variable 'runtime'"
  default = [
    "nodejs4.3",
    "nodejs6.10",
    "nodejs8.10",
    "nodejs10.x",
    "python2.7",
    "python3.6",
  ]
}

variable "lambda_service_role" {
  type        = map(string)
  description = "Service roles assigned to VPC and non-VPC Lambdas"
  default = {
    "basic" = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    "vpc"   = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  }
}

locals {
  # Select right service role depending on VPC or non-VPC setup
  lambda_service_role = length(var.subnet_ids) == 0 ? var.lambda_service_role["basic"] : var.lambda_service_role["vpc"]

  # Validate runtime input
  runtime = zipmap(var.supported_runtimes, var.supported_runtimes)[var.runtime]

  # Prefix Lambda role name with 'lambda-'
  aws_iam_role_name = format("lambda-%s", var.function_name)

  # Compute count of attach_policies and inline_policies here to workaround TF issue
  # https://github.com/hashicorp/terraform/issues/12570#issuecomment-359886242
  attach_policies_count = length(var.attach_policies)
  inline_policies_count = length(var.inline_policies)

  # empty function archive file
  empty_function = "${path.module}/empty-function.zip"

  # build base path
  tmp_base_path = "${path.root}/.tmp"

  # get a common hash for this function
  function_name_hash = sha256(var.function_name)

  # build output folder
  function_build_path = "${local.tmp_base_path}/build-${local.function_name_hash}"

  # Get the right archive file and hash to deploy
  deploy_archive_file = coalesce(
    join(",", data.archive_file.lambda_deploy_build.*.output_path),
    local.empty_function,
  )
  deploy_archive_hash = coalesce(
    join(
      ",",
      data.archive_file.lambda_deploy_build.*.output_base64sha256,
    ),
    base64sha256(filesha256(local.empty_function)),
  )
}


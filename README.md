# AWS Lambda function terraform module

A Terraform module to create an AWS Lambda function, its IAM role and optionally deploy the source code


## Requirements to manage code deployment

Function source code is built locally using this Docker image https://github.com/lambci/docker-lambda


## Module Input Variables

### Mandatory arguments

- `function_name` - name for the Lambda function
- `runtime` - lambda function runtime (see supported runtimes)
- `handler` - name of the function that Lambda will call to start running

### Optional arguments

- `count` - Whether to create a lambda function or not at all (defaults to _1_)
- `description` - lambda function description
- `source_code_path` - path to function's source code to manage deployment (defaults to _""_)
- `timeout` - function execution time in seconds after which Lambda terminates the function (defaults to _10_)
- `memory_size` - amount of memory in MB allocated to the Lambda function (defaults to _128_)
- `subnet_ids` - list of subnet IDs to run the Lambda in the private VPC they belong to (defaults to _[]_)
- `security_group_ids` - list of security group IDs to attach to the Lambda (defaults to _[]_)
- `env_variables` - map of environment variables passed to Lambda function (defaults to _{}_)
- `tags` - map of tags to add to the Lambda function (defaults to _{}_)
- `attach_policies` - list of IAM policies to attach to the Lambda role (defaults to _[]_)
- `inline_policies` - list of inline json policy documents to include in the Lambda role (defaults to _[]_)
- `publish` - Whether to publish creation/change as new Lambda Function Version (defaults to _true_)


## Usage

### Minimal Lambda function, no VPC, no code deployment

```hcl
module "lambda" {
  source        = "github.com/door2door-io/d2d-terraform-lambda?ref=v0.0.1"
  function_name = "my-lambda-function"
  handler       = "main.handler"
  runtime       = "nodejs6.10"
}
```

### VPC Lambda function plus code deployment management

```hcl
module "lambda" {
  source             = "github.com/door2door-io/d2d-terraform-lambda?ref=v0.0.1"
  function_name      = "my-lambda-function"
  source_code_path   = "path/to/source"
  handler            = "main.handler"
  runtime            = "nodejs6.10"
  subnet_ids         = ["subnet-01234567", "subnet-0abcdefg"]
  security_group_ids = ["sg-01234567", "sg-0abcdefg"]
}
```

### Complete VPC Lambda function example

```hcl
module "lambda" {
  source             = "github.com/door2door-io/d2d-terraform-lambda?ref=v0.0.1"
  function_name      = "my-lambda-function"
  source_code_path   = "path/to/source"
  handler            = "main.handler"
  runtime            = "nodejs6.10"
  timeout            = "30"
  memory_size        = "256"
  subnet_ids         = ["subnet-01234567", "subnet-0abcdefg"]
  security_group_ids = ["sg-01234567", "sg-0abcdefg"]
  attach_policies    = ["arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"]
  inline_policies    = ["${data.aws_iam_policy_document.access_to_ssm_parameters.json}"]
  env_variables      = {
    LOG_LEVEL = "DEBUG"
  }
  tags {
    "Terraform"   = "true"
    "Environment" = "test"
  }
}
```

### Supported runtimes

- nodejs4.3
- nodejs6.10
- python2.7
- python3.6


## Outputs

 - `lambda_arn` - ARN of the Lambda function
 - `role_arn` - ARN of the execution role for the Lambda function
 - `role_name` - name of the execution role for the Lambda function
 - `qualified_arn` - the Amazon Resource Name (ARN) identifying your Lambda Function Version (if versioning is enabled via publish = true)
 - `invoke_arn` - the ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri
 - `version` - latest published version of your Lambda Function
 - `last_modified` - the date this resource was last modified
 - `source_code_hash` - base64-encoded representation of raw SHA-256 sum of the zip file, provided either via filename or s3_* parameters
 - `source_code_size` - the size in bytes of the function .zip file

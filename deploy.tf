###############################################################################
# Manage deploy is enabled

# build deployment package
resource "null_resource" "lambda_build" {
  count = var.source_code_path != "" ? 1 : 0
  triggers = {
    always_run = uuid()
  }
  provisioner "local-exec" {
    command = "${path.module}/package.sh ${local.runtime} ${var.source_code_path} ${local.function_build_path}"
  }
}

# create zip archive from build folder to deploy
data "archive_file" "lambda_deploy_build" {
  count       = var.source_code_path != "" ? 1 : 0
  type        = "zip"
  source_dir  = local.function_build_path
  output_path = "${local.tmp_base_path}/deploy-${local.function_name_hash}.zip"
  depends_on  = [null_resource.lambda_build]
}


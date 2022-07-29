data "aws_caller_identity" "current" {}

resource "aws_iam_service_linked_role" "lakeformation" {
  count = module.this.enabled ? 1 : 0

  aws_service_name = "lakeformation.amazonaws.com"
}

module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "2.0.3"

  acl                = "private"
  versioning_enabled = false
  force_destroy      = true

  context = module.this.context
}

resource "aws_athena_database" "default" {
  count = module.this.enabled ? 1 : 0

  name   = var.resources.database.name
  bucket = module.s3_bucket.bucket_id

  force_destroy = true
}

module "example" {
  depends_on = [aws_athena_database.default]

  source = "../.."

  s3_bucket_arn           = module.s3_bucket.bucket_arn
  role_arn                = try(aws_iam_service_linked_role.lakeformation[0].arn, null)
  admin_arn_list          = [data.aws_caller_identity.current.arn]
  trusted_resource_owners = [data.aws_caller_identity.current.account_id]

  lf_tags   = var.lf_tags
  resources = var.resources

  database_default_permissions = [
    {
      permissions = ["ALL"]
      principal   = "IAM_ALLOWED_PRINCIPALS"
    }
  ]

  context = module.this.context
}

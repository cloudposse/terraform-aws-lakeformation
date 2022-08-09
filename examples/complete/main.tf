# We'll use the current user as Lake Formation admin 
data "aws_caller_identity" "current" {}

# Use this if a service-linked role already exists, otherwise it must be created
data "aws_iam_role" "lakeformation" {
  name = "AWSServiceRoleForLakeFormationDataAccess"
}

# Create a bucket to store Lake Formation data
module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "2.0.3"

  acl                = "private"
  versioning_enabled = false
  force_destroy      = true

  context = module.this.context
}

# Create an Athena database linked to an S3 bucket
resource "aws_athena_database" "default" {
  count = module.this.enabled ? 1 : 0

  name   = var.resources.database.name
  bucket = module.s3_bucket.bucket_id

  force_destroy = true
}

module "lakeformation" {
  source = "../.."

  s3_bucket_arn           = module.s3_bucket.bucket_arn
  role_arn                = data.aws_iam_role.lakeformation.arn
  admin_arn_list          = [data.aws_caller_identity.current.arn]
  trusted_resource_owners = [data.aws_caller_identity.current.account_id]

  lf_tags   = var.lakeformation_tags
  resources = var.resources

  database_default_permissions = [
    {
      permissions = ["ALL"]
      principal   = "IAM_ALLOWED_PRINCIPALS"
    }
  ]

  context = module.this.context

  depends_on = [aws_athena_database.default]
}

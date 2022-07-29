module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "2.0.0"

  enabled            = true
  acl                = "private"
  versioning_enabled = false

  context = module.this.context
}

module "example" {
  source = "../.."

  s3_bucket_arn = module.s3_bucket.bucket_arn
  lf_tags       = var.lf_tags
  resources     = var.resources

  context = module.this.context
}

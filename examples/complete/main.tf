module "example" {
  source = "../.."

  s3_bucket_arn = "foo"
  lf_tags       = var.lf_tags
  resources     = var.resources

  context = module.this.context
}

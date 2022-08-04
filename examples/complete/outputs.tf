output "s3_bucket_id" {
  description = "Name of S3 bucket created to store data."
  value       = module.s3_bucket.bucket_id
}

output "lakeformation_tags" {
  description = "List of Lake Formation tags created."
  value       = module.lakeformation.lf_tags
}

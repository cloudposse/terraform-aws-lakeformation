output "s3_bucket_id" {
  description = "Name of S3 bucket created to store data."
  value       = module.s3_bucket.bucket_id
}

output "lf_tags" {
  description = "List of LF tags created."
  value       = module.example.lf_tags
}

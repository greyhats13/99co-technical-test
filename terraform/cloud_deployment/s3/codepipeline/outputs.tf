output "s3_id" {
  value = module.s3_bucket.id
}

output "s3_arn" {
  value = module.s3_bucket.arn
}

output "s3_bucket_domain_name" {
  value = module.s3_bucket.bucket_domain_name
}

output "s3_bucket_name" {
  value = module.s3_bucket.bucket_name
}
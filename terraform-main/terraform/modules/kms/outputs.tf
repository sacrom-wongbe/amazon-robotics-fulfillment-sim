output "key_arn" {
  description = "The ARN of the KMS key"
  value       = module.kms.key_arn
}

output "key_id" {
  description = "The ID of the KMS key"
  value       = module.kms.key_id
}

output "key_alias_arn" {
  description = "The ARN of the KMS key alias"
  value       = module.kms.aliases["eks/${var.app_name}"].arn
}

output "key_alias_name" {
  description = "The name of the KMS key alias"
  value       = module.kms.aliases["eks/${var.app_name}"].name
}
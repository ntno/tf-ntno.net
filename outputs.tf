output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "portfolio_site_cloudfront_distribution_id" {
  description = "portfoliio site's cloudfront distribution id"
  value       = module.portfolio_site.content_cloudfront_distribution_info.id
}

output "ci_role_arn" {
  description = "CI IAM Role ARN"
  value       = module.portfolio_site_ci_cd.ci_role_arn
}

output "cd_role_arn" {
  description = "CD IAM Role ARN"
  value       = module.portfolio_site_ci_cd.cd_role_arn
}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "portfolio_site_cloudfront_distribution_id" {
  description = "portfoliio site's cloudfront distribution id"
  value       = module.portfolio_site.content_cloudfront_distribution_info.id
}

output "ci_role_name" {
  description = "CI IAM Role Name"
  value       = module.portfolio_site_ci_cd.ci_role_name
}

output "cd_role_name" {
  description = "CD IAM Role Name"
  value       = module.portfolio_site_ci_cd.cd_role_name
}
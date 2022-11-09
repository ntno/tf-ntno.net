output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "portfolio_site_cloudfront_distribution_id" {
  description = "portfoliio site's cloudfront distribution id"
  value       = module.portfolio_site.content_cloudfront_distribution_info.id
}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "portfolio_site_cloudfront_distribution_id" {
  description = "portfoliio site's cloudfront distribution id"
  value       = module.portfolio_site.content_cloudfront_distribution_info.id
}

output "ci_role_info" {
  description = "environment ID to map containing CI IAM Role ARN, prefix restriction, and github_environment_name"
  value = {
    for key, val in module.portfolio_site_cicd.ci_role_info : key => {
      ci_role_arn             = val.arn
      ci_prefix               = val.ci_prefix
      github_environment_name = val.github_environment_name
    }
  }
}

output "cd_role_info" {
  description = "environment ID to map containing CD IAM Role's arn and associated github_environment_name"
  value = {
    for key, val in module.portfolio_site_cicd.cd_role_info : key => {
      cd_role_arn             = val.arn
      github_environment_name = val.github_environment_name
    }
  }
}

output "artifact_bucket_info" {
  description = "artifact S3 bucket name"
  value = {
    name = module.portfolio_site_cicd.artifacts_bucket_info.id
  }
}
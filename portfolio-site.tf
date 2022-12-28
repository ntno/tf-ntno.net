module "portfolio_site" {
  source                        = "git::https://github.com/ntno/tf-module-static-site?ref=2.0.1"
  index_document                = "index.html"
  error_document                = "error.html"
  versioning_state              = "Enabled"
  domain_name                   = var.portfolio_domain_name
  domain_acm_certificate_arn    = data.aws_acm_certificate.ntno_cert.arn
  subdomain_acm_certificate_arn = data.aws_acm_certificate.star_ntno_cert.arn
  tags                          = local.global_tags

  advanced_config = {
    routing_rules = [
      {
        condition = {
          key_prefix_equals = "docs/img/"
        },
        redirect = {
          replace_key_prefix_with = "img/"
        }
      }
    ]
  }
}

module "portfolio_site_cicd" {
  source = "git::https://github.com/ntno/tf-module-static-site-cicd?ref=0.0.0"

  artifact_bucket_name = format("%s-artifacts", var.portfolio_domain_name)
  github_org           = "ntno"
  github_repo          = "ntno.net"
  tags                 = local.global_tags

  integration_environment = {
    environment_id          = "integration"
    github_environment_name = "gh-ci"
    ci_prefix               = "ntno-net-ci-pr-"
    tags = {
      project-environment = "integration"
    }
  }

  deployment_environments = {
    "production" = {
      deploy_bucket              = var.portfolio_domain_name
      github_environment_name    = "gh-prod"
      cloudfront_distribution_id = module.portfolio_site.content_cloudfront_distribution_info.id
      tags = {
        project-environment = "production"
      }
    }
  }
}

resource "aws_ssm_parameter" "portfolio_site_cloudfront_distribution_id" {
  name  = format("/%s/cloudfront/id", var.portfolio_domain_name)
  type  = "String"
  value = module.portfolio_site.content_cloudfront_distribution_info.id
  tags  = local.global_tags
}
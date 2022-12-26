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

module "portfolio_site_ci_cd" {
  source                     = "git::https://github.com/ntno/tf-module-static-site-cicd?ref=update-oidc-permissions"
  site_bucket                = var.portfolio_domain_name
  artifact_bucket_name       = format("%s-artifacts", var.portfolio_domain_name)
  ci_prefix                  = "ntno-net-ci-pr"
  ci_role_name               = "CI-ntno-net"
  cd_role_name               = "CD-ntno-net"
  github_repo                = "ntno.net"
  github_org                 = "ntno"
  github_cd_environment_name = "prod"
  cloudfront_distribution_id = module.portfolio_site.content_cloudfront_distribution_info.id
  tags                       = local.global_tags
}

resource "aws_ssm_parameter" "portfolio_site_cloudfront_distribution_id" {
  name  = format("/%s/cloudfront/id", var.portfolio_domain_name)
  type  = "String"
  value = module.portfolio_site.content_cloudfront_distribution_info.id
  tags  = local.global_tags
}
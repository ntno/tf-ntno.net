module "portfolio_site" {
  source                        = "git::https://github.com/ntno/tf-module-static-site?ref=2.0.0"
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
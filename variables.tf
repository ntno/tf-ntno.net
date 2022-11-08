variable "region" {
  type        = string
  description = "The default AWS region for the resource provisioning"
}

variable "portfolio_domain_name" {
  description = "Name of portfolio site's custom domain name.  Must be owned by the AWS account.  Must be unique in S3."
  type        = string
}
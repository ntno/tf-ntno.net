

resource "aws_iam_policy" "read_write_ntnonet_cd_policy" {
  name        = format("ReadWrite_%s_S3", var.cd_user)
  path        = "/CustomerManaged/"
  description = format("Allows read/write on %s S3 bucket", var.portfolio_domain_name)
  tags        = local.global_tags

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetEncryptionConfiguration",
          "s3:DeleteObject",
          # "s3:DeleteObjectVersion"
        ]
        Effect = "Allow"
        Resource = [
          format("arn:aws:s3:::%s", var.portfolio_domain_name),
          format("arn:aws:s3:::%s/*", var.portfolio_domain_name)
        ]
      },
      {
        Action = [
          "s3:GetBucketPublicAccessBlock",
          "s3:GetBucketWebsite",
          "s3:GetBucketAcl",
          "s3:GetBucketPolicy"
        ]
        Effect = "Allow"
        Resource = [
          format("arn:aws:s3:::%s", var.portfolio_domain_name)
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "invalidate_cloudfront_cd_policy" {
  name        = format("InvalidateCloudfrontDistribution_%s", var.cd_user)
  path        = "/CustomerManaged/"
  description = format("Allows invalidate on %s Cloudfront Distribution", var.portfolio_domain_name)
  tags        = local.global_tags

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudfront:CreateInvalidation"
        ]
        Effect = "Allow"
        Resource = [
          format("arn:aws:cloudfront::%s:distribution/%s", data.aws_caller_identity.current.account_id, module.portfolio_site.content_cloudfront_distribution_info.id)
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "read_write_artifacts_cd_policy_attachment" {
  user       = var.cd_user
  policy_arn = aws_iam_policy.read_write_artifacts_policy.arn
}

resource "aws_iam_user_policy_attachment" "read_write_ssm_cd_policy_attachment" {
  user       = var.cd_user
  policy_arn = aws_iam_policy.read_write_ssm_policy.arn
}

resource "aws_iam_user_policy_attachment" "read_write_ntnonet_cd_policy_attachment" {
  user       = var.cd_user
  policy_arn = aws_iam_policy.read_write_ntnonet_cd_policy.arn
}

resource "aws_iam_user_policy_attachment" "invalidate_cloudfront_cd_policy_attachment" {
  user       = var.cd_user
  policy_arn = aws_iam_policy.invalidate_cloudfront_cd_policy.arn
}
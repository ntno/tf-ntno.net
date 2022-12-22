resource "aws_iam_policy" "read_write_artifacts_policy" {
  name        = format("ReadWrite_%s_Objects", aws_s3_bucket.artifacts_bucket.id)
  path        = "/CustomerManaged/"
  description = format("Allows read/write on %s objects", aws_s3_bucket.artifacts_bucket.id)
  tags        = local.global_tags

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetEncryptionConfiguration"
        ]
        Effect = "Allow"
        Resource = [
          format("arn:aws:s3:::%s", aws_s3_bucket.artifacts_bucket.id),
          format("arn:aws:s3:::%s/*", aws_s3_bucket.artifacts_bucket.id)
        ]
      }
    ]
  })
}


resource "aws_iam_policy" "read_write_ssm_policy" {
  name        = format("ReadWrite_%s_SSM_Parameters", var.portfolio_domain_name)
  path        = "/CustomerManaged/"
  description = format("Allows read/write on %s SSM parameters", var.portfolio_domain_name)
  tags        = local.global_tags

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:PutParameter",
          "ssm:LabelParameterVersion",
          "ssm:DeleteParameter",
          "ssm:UnlabelParameterVersion",
          "ssm:RemoveTagsFromResource",
          "ssm:GetParameterHistory",
          "ssm:AddTagsToResource",
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter",
          "ssm:DeleteParameters"
        ]
        Effect = "Allow"
        Resource = [
          format("arn:aws:ssm:*:%s:parameter/%s/*", data.aws_caller_identity.current.account_id, var.portfolio_domain_name)
        ]
      }
    ]
  })
}

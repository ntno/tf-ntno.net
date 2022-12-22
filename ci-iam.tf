

resource "aws_iam_policy" "read_write_ntnonet_ci_policy" {
  name        = format("ReadWrite_%s_S3", var.ci_user)
  path        = "/CustomerManaged/"
  description = format("Allows read/write on %s S3 buckets", var.ci_user)
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
          format("arn:aws:s3:::%s*", var.ci_user),
          format("arn:aws:s3:::%s*/*", var.ci_user)
        ]
      },
      {
        Action = [
          "s3:GetBucketPublicAccessBlock",
          "s3:PutBucketPublicAccessBlock",
          "s3:DeleteBucketWebsite",
          "s3:GetBucketWebsite",
          "s3:PutBucketWebsite",
          "s3:PutBucketPolicy",
          "s3:CreateBucket",
          "s3:GetBucketAcl",
          "s3:DeleteBucketPolicy",
          "s3:DeleteBucket",
          "s3:GetBucketPolicy"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::*",
          format("arn:aws:s3:::%s*", var.ci_user)
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "read_write_ntnonet_ci_stack_policy" {
  name        = format("ReadWrite_%s_CloudformationStack", var.ci_user)
  path        = "/CustomerManaged/"
  description = format("Allows read/write on %s Cloudformation Stacks", var.ci_user)
  tags        = local.global_tags

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudformation:RollbackStack",
          "cloudformation:CreateStack",
          "cloudformation:Describe*",
          "cloudformation:DeleteStack",
          "cloudformation:ListStackResources"
        ]
        Effect = "Allow"
        Resource = [
          format("arn:aws:cloudformation:*:%s:stack/%s*/*", data.aws_caller_identity.current.account_id, var.ci_user)
        ]
      }
    ]
  })
}





resource "aws_iam_user_policy_attachment" "read_write_artifacts_policy_attachment" {
  user       = var.ci_user
  policy_arn = aws_iam_policy.read_write_artifacts_policy.arn
}

resource "aws_iam_user_policy_attachment" "read_write_ssm_policy_attachment" {
  user       = var.ci_user
  policy_arn = aws_iam_policy.read_write_ssm_policy.arn
}

resource "aws_iam_user_policy_attachment" "read_write_ntnonet_ci_policy_attachment" {
  user       = var.ci_user
  policy_arn = aws_iam_policy.read_write_ntnonet_ci_policy.arn
}

resource "aws_iam_user_policy_attachment" "read_write_ntnonet_ci_stack_policy_attachment" {
  user       = var.ci_user
  policy_arn = aws_iam_policy.read_write_ntnonet_ci_stack_policy.arn
}
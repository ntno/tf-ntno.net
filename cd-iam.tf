

resource "aws_iam_policy" "read_write_ntnonet_cd_policy" {
  name        = format("ReadWrite_%s_S3", var.cd_user)
  path        = "/CustomerManaged/"
  description = format("Allows read/write on %s S3 buckets", var.cd_user)
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
          "s3:DeleteObjectVersion"
        ]
        Effect = "Allow"
        Resource = [
          format("arn:aws:s3:::%s*", var.cd_user),
          format("arn:aws:s3:::%s*/*", var.cd_user)
        ]
      },
      {
        Action = [
          "s3:GetBucketPublicAccessBlock",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutEncryptionConfiguration",
          "s3:DeleteBucketWebsite",
          "s3:GetBucketWebsite",
          "s3:PutBucketWebsite",
          "s3:PutBucketPolicy",
          "s3:CreateBucket",
          "s3:GetBucketAcl",
          "s3:PutBucketAcl",
          "s3:DeleteBucketPolicy",
          "s3:DeleteBucket",
          "s3:GetBucketPolicy"
        ]
        Effect = "Allow"
        Resource = [
          format("arn:aws:s3:::%s*", var.cd_user)
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "read_write_ntnonet_cd_stack_policy" {
  name        = format("ReadWrite_%s_CloudformationStack", var.cd_user)
  path        = "/CustomerManaged/"
  description = format("Allows read/write on %s Cloudformation Stacks", var.cd_user)
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
          format("arn:aws:cloudformation:*:%s:stack/%s*/*", data.aws_caller_identity.current.account_id, var.cd_user)
        ]
      }
    ]
  })
}



resource "aws_iam_user_policy_attachment" "read_write_artifacts_policy_attachment" {
  user       = var.cd_user
  policy_arn = aws_iam_policy.read_write_artifacts_policy.arn
}

resource "aws_iam_user_policy_attachment" "read_write_ssm_policy_attachment" {
  user       = var.cd_user
  policy_arn = aws_iam_policy.read_write_ssm_policy.arn
}

resource "aws_iam_user_policy_attachment" "read_write_ntnonet_cd_policy_attachment" {
  user       = var.cd_user
  policy_arn = aws_iam_policy.read_write_ntnonet_cd_policy.arn
}

resource "aws_iam_user_policy_attachment" "read_write_ntnonet_cd_stack_policy_attachment" {
  user       = var.cd_user
  policy_arn = aws_iam_policy.read_write_ntnonet_cd_stack_policy.arn
}
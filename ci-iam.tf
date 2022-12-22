

resource "aws_iam_policy" "read_write_ntnonet_ci_policy" {
  name        = format("ReadWrite_%s_S3", var.ci_user)
  path        = "/CustomerManaged/"
  description = format("Allows read/write on %s S3", var.ci_user)
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
          format("arn:aws:s3:::%s*", var.ci_user)
        ]
      }
    ]
  })
}


resource "aws_iam_user_policy_attachment" "read_write_ntnonet_policy_attachment" {
  user       = var.ci_user
  policy_arn = aws_iam_policy.read_write_ntnonet_ci_policy.arn
}
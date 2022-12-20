esource "aws_iam_policy" "read_write_artifacts_policy" {
    #replace(aws_s3_bucket.artifacts_bucket.id, ".", "_")
  name        = format("ReadWrite_%s_Objects",  aws_s3_bucket.artifacts_bucket.id)
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
        Effect   = "Allow"
        Resource = [
            format("arn:aws:s3:::%s", aws_s3_bucket.artifacts_bucket.id),
            format("arn:aws:s3:::%s/*", aws_s3_bucket.artifacts_bucket.id)
        ]
      }
    ]
  })
}


resource "aws_iam_user_policy_attachment" "read_write_artifacts_policy_attachment" {
  user       = var.ci_user
  policy_arn = aws_iam_policy.read_write_artifacts_policy.arn
}
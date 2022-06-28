
data "aws_iam_policy_document" "s3_bucket_policy_doc" {
  statement {
    principals {
      type        = "AWS"
      identifiers = var.external_accounts
    }
    actions = [
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
      "s3:ListMultipartUploadParts"
    ]
    resources = [
      aws_s3_bucket.s3_bucket.arn,
      "${aws_s3_bucket.s3_bucket.arn}/*"
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
    actions = [
      "s3:*"
    ]
    resources = [aws_s3_bucket.s3_bucket.arn]
  }
}

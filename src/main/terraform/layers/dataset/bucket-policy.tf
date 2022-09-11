
data "aws_iam_policy_document" "s3_dataset_bucket_policy_doc" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.jenkins.account_id]
    }
    actions = [
      "s3:*"
    ]
    resources = [aws_s3_bucket.s3_dataset_bucket.arn]
  }
}

data "aws_iam_policy_document" "s3_project_bucket_policy_doc" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.jenkins.account_id]
    }
    actions = [
      "s3:*"
    ]
    resources = [aws_s3_bucket.s3_project_bucket.arn]
  }
}
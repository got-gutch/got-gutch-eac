
data "aws_iam_policy_document" "s3_key_policy_doc" {
  statement {
    principals {
      type        = "AWS"
      identifiers = var.external_accounts
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.jenkins.account_id]
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }
}

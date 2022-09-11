
resource "aws_s3_bucket" "s3_dataset_bucket" {
  bucket        = "${local.namespace}-dataset-bucket"
  force_destroy = var.force_destroy_dataset

  tags = {
    resource_group = local.namespace
  }
}

resource "aws_s3_bucket" "s3_project_bucket" {
  bucket        = "${local.namespace}-project-bucket"
  force_destroy = var.force_destroy_dataset

  tags = {
    resource_group = local.namespace
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_dataset_bucket_server_side_encryption_configuration" {
  bucket = aws_s3_bucket.s3_dataset_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_dataset_bucket" {
  bucket                  = aws_s3_bucket.s3_dataset_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "s3_dataset_access_from_another_account" {
  bucket = aws_s3_bucket.s3_dataset_bucket.id
  policy = data.aws_iam_policy_document.s3_dataset_bucket_policy_doc.json
}

resource "aws_s3_bucket_ownership_controls" "s3_dataset_bucket_ownership_controls" {
  bucket = aws_s3_bucket.s3_dataset_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "s3_project_bucket_server_side_encryption_configuration" {
  bucket = aws_s3_bucket.s3_project_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_project_bucket" {
  bucket                  = aws_s3_bucket.s3_project_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_project_access_from_another_account" {
  bucket = aws_s3_bucket.s3_project_bucket.id
  policy = data.aws_iam_policy_document.s3_project_bucket_policy_doc.json
}

resource "aws_s3_bucket_ownership_controls" "s3_project_bucket_ownership_controls" {
  bucket = aws_s3_bucket.s3_project_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

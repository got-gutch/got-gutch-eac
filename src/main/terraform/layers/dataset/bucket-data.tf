
resource "aws_s3_object" "simple-dataset" {
  bucket             = aws_s3_bucket.s3_bucket.id
  key                = "simple-dataset/health.csv"
  source             = "resources/simple-dataset/health.csv"
  bucket_key_enabled = true
  depends_on         = [aws_s3_bucket_ownership_controls.s3_bucket_bucket_ownership_controls]
}

resource "aws_s3_bucket" "raw" {
  bucket  = "${var.app_name}-${var.app_environment}-raw"
  acl     = "private"
}
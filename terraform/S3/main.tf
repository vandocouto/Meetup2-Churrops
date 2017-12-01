resource "aws_s3_bucket" "project-kube" {
  bucket = "project-kube"
  acl = "private"
  force_destroy = true

  tags {
    Name = "project-kube"
    Environment = "prod"
  }
  lifecycle {
    create_before_destroy = true
  }
}


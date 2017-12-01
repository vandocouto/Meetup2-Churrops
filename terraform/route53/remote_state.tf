terraform {
  backend "s3" {
    bucket = "project-kube"
    encrypt = "true"
    key = "route53/route53.tfstate"
    region = "us-east-1"
  }
}
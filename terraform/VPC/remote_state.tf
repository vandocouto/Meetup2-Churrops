terraform {
  backend "s3" {
    bucket = "project-kube"
    encrypt = "true"
    key = "vpc/vpc.tfstate"
    region = "us-east-1"
  }
}
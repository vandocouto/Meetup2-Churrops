terraform {
  backend "s3" {
    bucket = "project-kube"
    encrypt = "true"
    key = "ec2/jenkins_registry.tfstate"
    region = "us-east-1"
  }
}
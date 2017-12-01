terraform {
  backend "s3" {
    bucket = "project-kube"
    encrypt = "true"
    key = "sg/jenkins_registry.tfstate"
    region = "us-east-1"
  }
}
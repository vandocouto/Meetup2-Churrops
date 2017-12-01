data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "project-kube"
    key = "vpc/vpc.tfstate"
    region = "us-east-1"
    dynamodb_table = "TerraLockerFromTF"
  }
}

resource "aws_security_group" "jenkins_registry" {
  name = "jenkins_registry"
  vpc_id = "${data.terraform_remote_state.vpc.2}"

  tags {
    Name = "jenkins_registry"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "10.0.0.0/21"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}
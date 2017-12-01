data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "project-kube"
    key = "vpc/vpc.tfstate"
    region = "us-east-1"
    dynamodb_table = "TerraLockerFromTF"
  }
}

data "terraform_remote_state" "jenkins" {
  backend = "s3"
  config {
    bucket = "project-kube"
    key = "ec2/jenkins_registry.tfstate"
    region = "us-east-1"
    dynamodb_table = "TerraLockerFromTF"
  }
}

resource "aws_route53_zone" "primary" {
  name = "${var.domain}"
  force_destroy = true
  vpc_id = "${data.terraform_remote_state.vpc.2}"
}

resource "aws_route53_record" "jenkins" {
	zone_id = "${aws_route53_zone.primary.id}"
	name = "jenkins.churrops.com"
	type = "A"
	ttl = "30"
	records = ["${data.terraform_remote_state.jenkins.2}"]
}

resource "aws_route53_record" "registry" {
	zone_id = "${aws_route53_zone.primary.id}"
	name = "registry.churrops.com"
	type = "A"
	ttl = "30"
	records = ["${data.terraform_remote_state.jenkins.2}"]
}
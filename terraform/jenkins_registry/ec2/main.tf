data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "project-kube"
    key = "vpc/vpc.tfstate"
    region = "us-east-1"
    dynamodb_table = "TerraLockerFromTF"
  }
}

data "terraform_remote_state" "sg" {
  backend = "s3"
  config {
    bucket = "project-kube"
    key = "sg/jenkins_registry.tfstate"
    region = "us-east-1"
    dynamodb_table = "TerraLockerFromTF"
  }
}

resource "aws_eip" "ip-wan" {
  instance = "${aws_instance.jenkins_registry.id}"
  depends_on = [
    "aws_instance.jenkins_registry"]
  vpc = true
}

resource "aws_key_pair" "key-public" {
  key_name = "jenkins_registry"
  public_key = "${file("../../../chaves/churrops.pem.pub")}"
}

# deploy kubernetes master
resource "aws_instance" "jenkins_registry" {
  count = "1"
  subnet_id = "${data.terraform_remote_state.vpc.4}"
  instance_type = "${var.type}"
  ami = "${var.ami}"
  key_name = "jenkins_registry"
  security_groups = [
    "${element(data.terraform_remote_state.sg.1, count.index)}"]
  associate_public_ip_address = true

  root_block_device {
    volume_size = "${var.size_so}"
    volume_type = "${var.type_disk_so}"
  }

  tags {
    Name = "${var.tag}"
  }

  provisioner "remote-exec" {
    connection {
      user = "${var.ssh_user_name}"
      private_key = "${file("../../../chaves/churrops.pem")}"
    }

    inline = [
      "sudo apt-get update -y"
      ]
  }
}
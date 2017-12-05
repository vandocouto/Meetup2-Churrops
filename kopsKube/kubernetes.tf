output "cluster_name" {
  value = "churrops.com"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-churrops-com.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-churrops-com.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-churrops-com.name}"
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-churrops-com.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.us-east-1d-churrops-com.id}", "${aws_subnet.us-east-1e-churrops-com.id}", "${aws_subnet.us-east-1f-churrops-com.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-churrops-com.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-churrops-com.name}"
}

output "region" {
  value = "us-east-1"
}

output "vpc_id" {
  value = "vpc-972551ef"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_autoscaling_group" "master-us-east-1d-masters-churrops-com" {
  name                 = "master-us-east-1d.masters.churrops.com"
  launch_configuration = "${aws_launch_configuration.master-us-east-1d-masters-churrops-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-east-1d-churrops-com.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "churrops.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-east-1d.masters.churrops.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "master-us-east-1e-masters-churrops-com" {
  name                 = "master-us-east-1e.masters.churrops.com"
  launch_configuration = "${aws_launch_configuration.master-us-east-1e-masters-churrops-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-east-1e-churrops-com.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "churrops.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-east-1e.masters.churrops.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "master-us-east-1f-masters-churrops-com" {
  name                 = "master-us-east-1f.masters.churrops.com"
  launch_configuration = "${aws_launch_configuration.master-us-east-1f-masters-churrops-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-east-1f-churrops-com.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "churrops.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-east-1f.masters.churrops.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "nodes-churrops-com" {
  name                 = "nodes.churrops.com"
  launch_configuration = "${aws_launch_configuration.nodes-churrops-com.id}"
  max_size             = 3
  min_size             = 3
  vpc_zone_identifier  = ["${aws_subnet.us-east-1d-churrops-com.id}", "${aws_subnet.us-east-1e-churrops-com.id}", "${aws_subnet.us-east-1f-churrops-com.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "churrops.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.churrops.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "d-etcd-events-churrops-com" {
  availability_zone = "us-east-1d"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "churrops.com"
    Name                 = "d.etcd-events.churrops.com"
    "k8s.io/etcd/events" = "d/d,e,f"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "d-etcd-main-churrops-com" {
  availability_zone = "us-east-1d"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "churrops.com"
    Name                 = "d.etcd-main.churrops.com"
    "k8s.io/etcd/main"   = "d/d,e,f"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "e-etcd-events-churrops-com" {
  availability_zone = "us-east-1e"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "churrops.com"
    Name                 = "e.etcd-events.churrops.com"
    "k8s.io/etcd/events" = "e/d,e,f"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "e-etcd-main-churrops-com" {
  availability_zone = "us-east-1e"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "churrops.com"
    Name                 = "e.etcd-main.churrops.com"
    "k8s.io/etcd/main"   = "e/d,e,f"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "f-etcd-events-churrops-com" {
  availability_zone = "us-east-1f"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "churrops.com"
    Name                 = "f.etcd-events.churrops.com"
    "k8s.io/etcd/events" = "f/d,e,f"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "f-etcd-main-churrops-com" {
  availability_zone = "us-east-1f"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "churrops.com"
    Name                 = "f.etcd-main.churrops.com"
    "k8s.io/etcd/main"   = "f/d,e,f"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_iam_instance_profile" "masters-churrops-com" {
  name = "masters.churrops.com"
  role = "${aws_iam_role.masters-churrops-com.name}"
}

resource "aws_iam_instance_profile" "nodes-churrops-com" {
  name = "nodes.churrops.com"
  role = "${aws_iam_role.nodes-churrops-com.name}"
}

resource "aws_iam_role" "masters-churrops-com" {
  name               = "masters.churrops.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.churrops.com_policy")}"
}

resource "aws_iam_role" "nodes-churrops-com" {
  name               = "nodes.churrops.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.churrops.com_policy")}"
}

resource "aws_iam_role_policy" "masters-churrops-com" {
  name   = "masters.churrops.com"
  role   = "${aws_iam_role.masters-churrops-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.churrops.com_policy")}"
}

resource "aws_iam_role_policy" "nodes-churrops-com" {
  name   = "nodes.churrops.com"
  role   = "${aws_iam_role.nodes-churrops-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.churrops.com_policy")}"
}

resource "aws_key_pair" "kubernetes-churrops-com-775893c934ee41427a0a3d6c0756bb19" {
  key_name   = "kubernetes.churrops.com-77:58:93:c9:34:ee:41:42:7a:0a:3d:6c:07:56:bb:19"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.churrops.com-775893c934ee41427a0a3d6c0756bb19_public_key")}"
}

resource "aws_launch_configuration" "master-us-east-1d-masters-churrops-com" {
  name_prefix                 = "master-us-east-1d.masters.churrops.com-"
  image_id                    = "ami-44e2843e"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-churrops-com-775893c934ee41427a0a3d6c0756bb19.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-churrops-com.id}"
  security_groups             = ["${aws_security_group.masters-churrops-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-east-1d.masters.churrops.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 40
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "master-us-east-1e-masters-churrops-com" {
  name_prefix                 = "master-us-east-1e.masters.churrops.com-"
  image_id                    = "ami-44e2843e"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-churrops-com-775893c934ee41427a0a3d6c0756bb19.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-churrops-com.id}"
  security_groups             = ["${aws_security_group.masters-churrops-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-east-1e.masters.churrops.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 40
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "master-us-east-1f-masters-churrops-com" {
  name_prefix                 = "master-us-east-1f.masters.churrops.com-"
  image_id                    = "ami-44e2843e"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-churrops-com-775893c934ee41427a0a3d6c0756bb19.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-churrops-com.id}"
  security_groups             = ["${aws_security_group.masters-churrops-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-east-1f.masters.churrops.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 40
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "nodes-churrops-com" {
  name_prefix                 = "nodes.churrops.com-"
  image_id                    = "ami-44e2843e"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-churrops-com-775893c934ee41427a0a3d6c0756bb19.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-churrops-com.id}"
  security_groups             = ["${aws_security_group.nodes-churrops-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.churrops.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.churrops-com.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "igw-1e80ea67"
}

resource "aws_route_table" "churrops-com" {
  vpc_id = "vpc-972551ef"

  tags = {
    KubernetesCluster = "churrops.com"
    Name              = "churrops.com"
  }
}

resource "aws_route_table_association" "us-east-1d-churrops-com" {
  subnet_id      = "${aws_subnet.us-east-1d-churrops-com.id}"
  route_table_id = "${aws_route_table.churrops-com.id}"
}

resource "aws_route_table_association" "us-east-1e-churrops-com" {
  subnet_id      = "${aws_subnet.us-east-1e-churrops-com.id}"
  route_table_id = "${aws_route_table.churrops-com.id}"
}

resource "aws_route_table_association" "us-east-1f-churrops-com" {
  subnet_id      = "${aws_subnet.us-east-1f-churrops-com.id}"
  route_table_id = "${aws_route_table.churrops-com.id}"
}

resource "aws_security_group" "masters-churrops-com" {
  name        = "masters.churrops.com"
  vpc_id      = "vpc-972551ef"
  description = "Security group for masters"

  tags = {
    KubernetesCluster = "churrops.com"
    Name              = "masters.churrops.com"
  }
}

resource "aws_security_group" "nodes-churrops-com" {
  name        = "nodes.churrops.com"
  vpc_id      = "vpc-972551ef"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "churrops.com"
    Name              = "nodes.churrops.com"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-churrops-com.id}"
  source_security_group_id = "${aws_security_group.masters-churrops-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-churrops-com.id}"
  source_security_group_id = "${aws_security_group.masters-churrops-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-churrops-com.id}"
  source_security_group_id = "${aws_security_group.nodes-churrops-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-churrops-com.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-churrops-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-churrops-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-churrops-com.id}"
  source_security_group_id = "${aws_security_group.nodes-churrops-com.id}"
  from_port                = 1
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-churrops-com.id}"
  source_security_group_id = "${aws_security_group.nodes-churrops-com.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-churrops-com.id}"
  source_security_group_id = "${aws_security_group.nodes-churrops-com.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-churrops-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-churrops-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "us-east-1d-churrops-com" {
  vpc_id            = "vpc-972551ef"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1d"

  tags = {
    KubernetesCluster                    = "churrops.com"
    Name                                 = "us-east-1d.churrops.com"
    "kubernetes.io/cluster/churrops.com" = "owned"
  }
}

resource "aws_subnet" "us-east-1e-churrops-com" {
  vpc_id            = "vpc-972551ef"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1e"

  tags = {
    KubernetesCluster                    = "churrops.com"
    Name                                 = "us-east-1e.churrops.com"
    "kubernetes.io/cluster/churrops.com" = "owned"
  }
}

resource "aws_subnet" "us-east-1f-churrops-com" {
  vpc_id            = "vpc-972551ef"
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1f"

  tags = {
    KubernetesCluster                    = "churrops.com"
    Name                                 = "us-east-1f.churrops.com"
    "kubernetes.io/cluster/churrops.com" = "owned"
  }
}

terraform = {
  required_version = ">= 0.9.3"
}

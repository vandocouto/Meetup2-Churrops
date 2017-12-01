output "1" {
  value = "${aws_default_security_group.default.id}"
}

output "2" {
  value = "${aws_vpc.vpc.id}"
}

output "3" {
  value = "${aws_internet_gateway.ig.id}"
}

//output "4" {
//  value = "${aws_subnet.subnets.*.id}"
//}


output "4" {
  value = "${aws_subnet.subnets.id}"
}





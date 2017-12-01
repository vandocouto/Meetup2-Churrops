# output
output "1" {
        value = "${join (",", aws_eip.ip-wan.*.public_ip)}"
}

output "2" {
  value = "${join(",", aws_instance.jenkins_registry.*.private_ip)}"

}

output "3" {
  value = "${join(",", aws_instance.jenkins_registry.*.id)}"
}

output "4" {
  value = "${join(",", aws_instance.jenkins_registry.*.public_ip)}"

}

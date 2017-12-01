output "1" {
  value = ["${aws_security_group.jenkins_registry.*.id}"]
}
#!/bin/bash


packer build -machine-readable packer/ami-default.json | tee packer/ami-default.log >> /dev/null
AMI=$(egrep -m1 -oe 'ami-.{8}' packer/ami-default.log)

echo $AMI

cat <<EOF > terraform/jenkins_registry/ec2/ami.tf
variable "ami" {
  default = "$AMI"
}
EOF

packer build -machine-readable packer/ami-kops.json | tee packer/ami-kops.log >> /dev/null
AMI=$(egrep -m1 -oe 'ami-.{8}' packer/ami-kops.log)

echo $AMI

cat <<EOF > kops/ami_kops.txt
$AMI
EOF
#!/usr/bin/python

import json
import io
import subprocess
import re
import random
import sys

try:
    to_unicode = unicode
except NameError:
    to_unicode = str

command_terraform = subprocess.Popen(["terraform/build.sh", "terraform/VPC/", "output"], stdout=subprocess.PIPE)
output = str(command_terraform.communicate())
ips = str(output.split(','))
replaced = re.sub('[\'=\[()\\\\/\],'']', '', ips).split(' ')

# print (replaced)
# variables output
sg = str(replaced[2][0:-2])
vpc = str(replaced[4][0:-2])
subnet = str(replaced[8][0:-2])
id = "Image-Docker-id-%s" % random.randrange(100)
version = sys.argv[1]
print(sg, vpc, subnet, id)

data = {
    "builders": [
        {
            "ssh_username": "ubuntu",
            "communicator": "ssh",
            "source_ami_filter": {
                "filters": {
                    "virtualization-type": "hvm",
                    "name": "*ubuntu-xenial-16.04-amd64-server-*",
                    "root-device-type": "ebs"
                },
                "most_recent": "true",
            },
            "subnet_id": "" + subnet + "",
            "region": "us-east-1",
            "ami_name": id,
            "security_group_id": "" + sg + "",
            "instance_type": "t2.micro",
            "ssh_private_ip": "false",
            "associate_public_ip_address": "true",
            "vpc_id": "" + vpc + "",
            "type": "amazon-ebs",
            "ssh_pty": "true"
        }
    ],

    "provisioners": [
        {
            "type": "shell",
            "script": "packer/" + version + ".sh"
        }
    ]
}

with io.open('packer/ami-' + version + '.json', 'w', encoding='utf8') as outfile:
    str_ = json.dumps(data,
                      indent=2, sort_keys=False,
                      separators=(',', ': '), ensure_ascii=False)
    outfile.write(to_unicode(str_))

with open('packer/ami-' + version + '.json') as data_file:
    data_loaded = json.load(data_file)

print(data_loaded)


import subprocess
import re

# get command
#command_terraform = subprocess.Popen(["./deploy.sh", "ec2-churrops/", "output"], stdout=subprocess.PIPE)
command_terraform = subprocess.Popen(["terraform/build.sh", "terraform/jenkins_registry/ec2/", "output"], stdout=subprocess.PIPE)

output=str(command_terraform.communicate())
ips=str(output.split(','))
#print (ips)

replaced = re.sub('[n|a-z|A-Z|\'=\[()\\\\/\],'']', '', ips).split(' ')
lan=(replaced[4][0:-1])
wan=(replaced[2][0:-1])

print (lan, wan)

 # generate file hosts
file = open("ansible/jenkins_registry/hosts", "w")
file.write("[docker-engine]\n\
%s  hostname=churrops\n\
[all:vars]\n\
docker_swarm_port=2377\n\
ansible_ssh_user=ubuntu\n\
ansible_ssh_private_key_file=chaves/churrops.pem\n\
##\n\
##\n\
registry=registry.churrops.com\n\
jenkinsuser=admin\n\
lan=%s\n\
" %(wan,lan
   ))

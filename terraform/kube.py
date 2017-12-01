import subprocess
import re


def out(ec2):
    command_terraform = subprocess.Popen(["./build.sh", "kube-" + ec2 + "/ec2/", "output"], stdout=subprocess.PIPE)
    output = str(command_terraform.communicate())
    ips = str(output.split(','))
    replaced = re.sub('[n|a-z|A-Z|\'=\[()\\\\/\],'']', '', ips).split(' ')
    return (replaced)


master1w = out("master")[2][0:-1]
master2w = out("master")[3][0:-1]
master1l = out("master")[5]

node1w = out("node")[2][0:-1]
node2w = out("node")[3][0:-1]

print(master1l, master1w, master2w, node1w, node2w)

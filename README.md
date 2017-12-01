Ambiente local:

* Ansible 2.4.1.0
* Jenkins 2.73.3
* Kops 1.7.0 
* Packer 1.1.1
* Python 2.7.12
* Terraform v0.10.8

1 - Configurado o Access Keys e Secret Keys da AWS

    export AWS_ACCESS_KEY_ID=""
    export AWS_SECRET_ACCESS_KEY=""
    export AWS_DEFAULT_REGION="us-east-1"

2 - Criando o Bucket na AWS S3

    ./terraform/build.sh terraform/S3/ init
    ./terraform/build.sh terraform/S3/ plan
    ./terraform/build.sh terraform/S3/ apply

3 - Gerando o par de chaves (privada - pública) 

    ssh-keygen -b 4096 -t rsa -N '' -C docker -f chaves/churrops.pem


4 - Criando a VPC kubernetes na AWS

     ./terraform/build.sh terraform/VPC/ init
     ./terraform/build.sh terraform/VPC/ plan
     ./terraform/build.sh terraform/VPC/ apply

5 - Criando a AMI (default e kops) na AWS

    python ./packer/ami.py default
    packer build -machine-readable packer/ami-default.json

    python ./packer/ami.py kops
    packer build -machine-readable packer/ami-kops.json

    sh var-ami.sh


6 - Criando a instância jenkins_registry (sg - ec2) na AWS

    ./terraform/build.sh terraform/jenkins_registry/sg/ init
    ./terraform/build.sh terraform/jenkins_registry/sg/ plan
    ./terraform/build.sh terraform/jenkins_registry/sg/ apply

    ./terraform/build.sh terraform/jenkins_registry/ec2/ init
    ./terraform/build.sh terraform/jenkins_registry/ec2/ plan
    ./terraform/build.sh terraform/jenkins_registry/ec2/ apply

7 - Exportando a senha do Jenkins Admin

    export JPASS=$(vault read -tls-skip-verify -format=json secret/jenkins-pass | jq -r .data.value)
    
    Ou

    export JPASS="Defina senha aqui"

8 - Deploy do container Jenkins e Registry na AWS

    python jenkins_regitry.py
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/jenkins_registry/hosts ansible/jenkins_registry/tasks/main.yml --extra-vars jenkinspass=$JPASS

9 - Criando os registros no Route53 (churrops.com)

    ./terraform/build.sh terraform/route53/ init
    ./terraform/build.sh terraform/route53/ plan
    ./terraform/build.sh terraform/route53/ apply

10 - Deploy do cluster Kubernetes com o Kops

    sh kops/deploy.sh
    cd ./kopsKube
    terraform init
    terraform plan
    terraform apply
    
Obs: Verifique no DNS (route53) os registros criados, ajuste no hosts ou gmask o fqdn api.churrops.com. 
Aguarde alguns minutos até que todos os registros sejam criados.

11 - Ajustando o fqdn api.churrops.com no hosts.

Exemplo: (/etc/hosts)

    
    IP   api.churrops.com
    

12 - Criando o secret docker-registry (regsecret) no cluster Kubernetes

    cd ../
    RPASS=$(vault read -tls-skip-verify -format=json secret/registry-pass | jq -r .data.value)
    ou
    RPASS="password"
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/kubernetes/hosts ./ansible/kubernetes/tasks/main.yml --extra-vars "passreg=$RPASS"
    
13 - Verificando se o secret foi criado com sucesso no cluster Kubernetes

    kubectl get secret regsecret -o yaml


13 - Listando todos os nodes do cluster Kubernetes

    kubectl get node
    
14 - Listando todos os services do cluster Kubernetes

    kubectl get svc
    
15 - Listando todos os containers (pods) do cluster Kubernetes

    kubectl get pod
    kubectl get pods --all-namespaces
     
16 - Listando todos os deployments (projetos)

    kubectl get deployments
    
17 - Subindo o nginx (sample-nginx) com 2 replicas

    kubectl run sample-nginx --image=nginx --replicas=2 --port=80

18 - Criando um Load Balance (sample-nginx)

    kubectl expose deployment sample-nginx --port=80 --type=LoadBalancer
    
19 - Listando todos os services criados

    kubectl get services -o wide
    
20 - Gerando o yaml do (sample-nginx)

    kubectl get svc sample-nginx -o yaml
    
21 - Deletando o deployment e o service (sample-nginx) 

    kubectl delete deployment sample-nginx
    kubectl delete service sample-nginx

22 - Listando as informações do cluster Kubernetes

    kubectl cluster-info
    kubectl cluster-info dump
    
23 - Listando todos os containers (pods) dos projeto1-pd e projeto1-st
Link do projeto: https://github.com/vandocouto/meetup-projeto1.git

    kubectl get pod 
    NAME                           READY     STATUS    RESTARTS   AGE
    projeto1-pd-78bc4dccbc-88r5h   1/1       Running   0          26m
    projeto1-pd-78bc4dccbc-96hpw   1/1       Running   0          26m
    projeto1-pd-78bc4dccbc-nc88n   1/1       Running   0          26m
    projeto1-st-565b556469-fmfn4   1/1       Running   0          25m
    projeto1-st-565b556469-nw8tn   1/1       Running   0          25m
    projeto1-st-565b556469-r45vd   1/1       Running   0          25m

24 - Acessando o container (pod) projeto1-pd-78bc4dccbc-88r5h
    
    kubectl exec -it projeto1-pd-78bc4dccbc-88r5h -- bash
    root@projeto1-pd-78bc4dccbc-88r5h:/# ls                                                                                                                                                                             
    bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  start.sh  sys  tmp  usr  var

25 - Criando o namespace demos, para o projeto php-apache

    kubectl create namespace demos

26 - Criando o pod php-apache 

    kubectl --namespace=demos run php-apache --image=gcr.io/google_containers/hpa-example --requests=cpu=128m,memory=128m --expose --port=80
    
27 - Listando as informações do namespace "demos"

    kubectl --namespace=demos get deployments
    kubectl --namespace=demos get svc -o wide
    kubectl --namespace=demos get pods
    kubectl --namespace=demos get events

28 - Criando o autoscaling do pod php-apache
    
    kubectl --namespace=demos autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
    kubectl get --namespace=demos hpa

29 - Gerando os arquivos yaml's do projeto php-apache (deployment - service - auto scaling)
    
    kubectl get --namespace=demos deploy php-apache -o yaml
    kubectl get --namespace=demos svc php-apache -o yaml
    kubectl get --namespace=demos hpa php-apache -o yaml
    
30 - Acessando o container
    
    kubectl --namespace=demos exec -it php-apache-5f67ddc9cc-6g8z6 -- bash
    
31 - Por fim, deletando o cluster Kubernetes

    kops delete cluster churrops.com  --state=s3://project-kube/kops --yes
    
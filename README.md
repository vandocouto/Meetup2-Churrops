# Criando um cluster Kubernetes 1.8.4 com o KOPS (Infra as Code)

### Ambiente local:

* Linux Ubuntu 16.04
* Ansible 2.4.1.0
* Jenkins 2.73.3
* Kops 1.7.0 
* Packer 1.1.1
* Python 2.7.12
* Terraform v0.10.8

### Clone do projeto:

    git clone https://github.com/vandocouto/Meetup2-Churrops.git
    cd Meetup2-Churrops

1 - Configurando o Access Keys/Secret Keys AWS

    export AWS_ACCESS_KEY_ID=""
    export AWS_SECRET_ACCESS_KEY=""
    export AWS_DEFAULT_REGION="us-east-1"

2 - Criando o Bucket no S3 (project-kube)

    ./terraform/build.sh terraform/S3/ init
    ./terraform/build.sh terraform/S3/ plan
    ./terraform/build.sh terraform/S3/ apply

3 - Gerando o par de chaves (privada - pública) que será utilizado no projeto 

    ssh-keygen -b 4096 -t rsa -N '' -C docker -f chaves/churrops.pem


4 - Criando a VPC kubernetes

     ./terraform/build.sh terraform/VPC/ init
     ./terraform/build.sh terraform/VPC/ plan
     ./terraform/build.sh terraform/VPC/ apply

5 - Criando a AMI (default e kops)

* AMI default - será utilizada para a instância jenkins_registry

* AMI kops - será utilizada para as instâncias do cluster Kubernetes


    python ./packer/ami.py default
    packer build -machine-readable packer/ami-default.json

    python ./packer/ami.py kops
    packer build -machine-readable packer/ami-kops.json

    sh var-ami.sh


6 - Criando a instância jenkins_registry (sg - ec2)

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

8 - Deploy do container Jenkins e Registry

    python jenkins_regitry.py
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/jenkins_registry/hosts ansible/jenkins_registry/tasks/main.yml --extra-vars jenkinspass=$JPASS

9 - Criando os registros no Route53 (churrops.com)

    ./terraform/build.sh terraform/route53/ init
    ./terraform/build.sh terraform/route53/ plan
    ./terraform/build.sh terraform/route53/ apply


### Configurando o Jenkins Churrops

Execute o comando abaixo:

    ./terraform/build.sh terraform/jenkins_registry/ec2/ output | grep "1 ="
    
Ajuste o IP no hosts/gmask. 
Exemplo:

    34.234.194.189	jenkins.churrops.com registry.churrops.com
    
Acesse o Jenkins <b>http://jenkins.churrops.com:8080</b>

Configure conforme as imagens abaixo:

* user: admin
* pass: doort22017

![alt text](images/login1.png#center "Login")

![alt text](images/login2.png#center "Login")

![alt text](images/login3.png#center "Login")

![alt text](images/1.png#center "Credentials")

![alt text](images/2.png#center "Registry")

![alt text](images/3.png#center "churropsPem")

![alt text](images/4.png#center "Github")

![alt text](images/6.png#center "Credentials")

![alt text](images/7.png#center)


10 - Deploy do cluster Kubernetes com o Kops (3 masters - 3 nodes)

    sh kops/deploy.sh
    cd ./kopsKube
    terraform init
    terraform plan
    terraform apply
    
Obs: Verifique no DNS (route53) os registros criados, ajuste o hosts/gmask o fqdn api.churrops.com. 
<br><b>Aguarde alguns minutos, até que todos os registro sejam criados.</b>

11 - Ajustando o fqdn api.churrops.com no hosts.

Exemplo: (/etc/hosts)

    
    IP   api.churrops.com
    

![alt text](images/kubernetes1.png#center)
    

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

### Configurando o primeiro Job (churrops-projeto1 ) no Jenkins

* Criando a credencial do slack

![alt text](images/slack-credentials.png#center)

* Configurando o canal do slack 

![alt text](images/slack-configuration-jenkins.png#center)

* Criando o Job MultiBranch

![alt text](images/job1.png#center)

![alt text](images/job2.png#center)

* Executando o job 

![alt text](images/jenkins-pipeline.png#center)

* Verificando o lb que foi criado na AWS

![alt text](images/lb.png#center)

* Acessando a app pela Web

![alt text](images/nginx.png#center)


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
    

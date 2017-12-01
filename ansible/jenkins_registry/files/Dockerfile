# imagem default
FROM openjdk:8-jdk

RUN apt-get update && apt-get install -y \
vim-tiny jq git curl zip unzip iputils-ping telnet \
net-tools apt-transport-https ca-certificates \
curl nfs-common python-pip dirmngr sudo libltdl7 && rm -rf /var/lib/apt/lists/*

ENV VAULT_VERSION 0.8.1
ENV TERRAFORM_VERSION 0.10.8

RUN wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip vault_${VAULT_VERSION}_linux_amd64.zip && \
    mv vault /usr/bin/ && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/bin && \
    rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    pip install ansible

COPY 91-jenkins /etc/sudoers.d/

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}

RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

VOLUME /var/jenkins_home

RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

ENV TINI_VERSION 0.14.0
ENV TINI_SHA 6c41ec7d33e857d4779f14d9c74924cab0c7973485d2972419a3b7c7620ff5fd

RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha256sum -c -

COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.73.3}

ARG JENKINS_SHA=fcfb932a84ce03795abbf51ae7799439278155b0d42242d1d79a187034649fc8

ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c -

ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref

EXPOSE ${http_port}

EXPOSE ${agent_port}

ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

USER ${user}

COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

COPY plugins.sh /usr/local/bin/plugins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh

COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
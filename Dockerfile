#FROM jenkinsci/jenkins
FROM jenkins:latest
MAINTAINER vincent.sesto@airnz.co.nz

# Install plugins
RUN /usr/local/bin/install-plugins.sh build-pipeline-plugin docker-plugin git ssh-credentials workflow-aggregator scm-api git-client greenballs docker-build-publish amazon-ecr docker-workflow

ENV JENKINS_USER admin
ENV JENKINS_PASS admin

# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/
ADD ref /usr/share/jenkins/ref/

USER root
RUN apt-get update && apt-get install -y rsync sudo python-setuptools python-dev build-essential && easy_install pip && pip install awscli && rm -rf /var/lib/apt/lists/*

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins

FROM jenkins/jenkins:lts-alpine

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt

VOLUME ["var/jenkins_home"]

EXPOSE 8080
EXPOSE 50000
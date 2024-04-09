#! /bin/bash
sudo apt update -y
sudo apt install openjdk-11-jdk -y
sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
sudo echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install jenkins -y
sudo systemctl enable jenkins
#plugin for jenkins
# wget http://your-jenkins-url/jnlpJars/jenkins-cli.jar
# java -jar jenkins-cli.jar -s http://your-jenkins-url/ -auth username:password install-plugin plugin-name
# java -jar jenkins-cli.jar -s http://your-jenkins-url/ -auth username:password safe-restart
# sudo systemctl restart jenkins

sudo apt-get install wget apt-transport-https gnupg lsb-release -y
#install trivy
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y 
sudo apt-get install trivy -y
#docker
sudo apt install docker.io -y
sudo chmod 666 /var/run/docker.sock
#kubectl
sudo snap install kubectl --classic



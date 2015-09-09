#!/bin/bash

PRE_REQ=0
HOME=`pwd`
# Checking prerequisites for the build
command -v docker >/dev/null 2>&1 || { echo >&2 "Missing Docker!!! Build required docker install in the host. Try 'curl -sSL https://get.docker.com/ | sh' "; $PRE_REQ=1; }

if [ ! $PRE_REQ -eq 0 ];then
    echo "All prerequisite not met. Existing build..."
    exit;
fi

echo "Pull and saving Kubernetes docker images....."
if [ ! -f images/etcd.tgz ];then
    echo "Pulling etcd docker image...."
    docker pull gcr.io/google_containers/etcd:2.0.9
    echo "Saving etcd docker image...."
    docker save gcr.io/google_containers/etcd > images/etcd.tgz
fi        
if [ ! -f images/hyperkube.tgz ];then
    echo "Pulling hyperkube docker image...."
    docker pull gcr.io/google_containers/hyperkube:v1.0.1
    echo "Saving hyperkube docker image...."
    docker save gcr.io/google_containers/hyperkube > images/hyperkube.tgz
fi
if [ ! -f images/pause.tgz ];then
    echo "Pulling pause docker image...."
    docker pull gcr.io/google_containers/pause:0.8.0
    echo "Saving pause docker image...."
    docker save gcr.io/google_containers/pause > images/pause.tgz
fi
if [ ! -f images/cadvisor.tgz ];then 
    echo "Pulling cadvisor docker image...."
    docker pull google/cadvisor:latest
    echo "Saving cadvisor docker image...."
    docker save google/cadvisor > images/cadvisor.tgz
fi

# Pull Tomcat docker image
echo "Pull and saving Tomcat docker images....."
if [ ! -f images/tomcat.tgz ];then
    echo "Pulling tomcat docker image...."
    docker pull tomcat
    echo "Saving tomcat docker image...."
    docker save tomcat > images/tomcat.tgz
fi

# Get boot2docker virtualbox for mac support
if [ ! -f images/boot2docker-virtualbox.box ];then
    echo "Download boot2docker virtualbox for mac support...."
    cd images
    wget https://github.com/YungSang/boot2docker-vagrant-box/releases/download/yungsang%2Fv1.4.1/boot2docker-virtualbox.box
    cd $HOME
fi

# Building C6Demo java app
if [ ! -d demo-app ];then
    echo "Clone source code from https://github.com/chirangaalwis/Java-Kubernetes-Web-Artifact-Handler.git"
    git clone https://github.com/chirangaalwis/Java-Kubernetes-Web-Artifact-Handler.git demo-app
    cd demo-app
else
    echo "Fetching new updates from https://github.com/chirangaalwis/Java-Kubernetes-Web-Artifact-Handler.git"
    cd demo-app
    git pull
fi
echo "Building POC Demo app..."
rm -fr target
mvn clean install
cd $HOME
cp -f demo-app/target/java-web-artifact-handler-1.0-SNAPSHOT.zip .

# Creating single pack
[ -f c6pocdemo.tgz ] && rm c6pocdemo.tgz
tar zcvf c6pocdemo.tgz images/ server.sh  Vagrantfile bootstrap.sh java-web-artifact-handler-1.0-SNAPSHOT.zip 




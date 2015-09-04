#!/bin/bash

command -v docker >/dev/null 2>&1 || { echo >&2 "Build required docker install in the host. Try 'curl -sSL https://get.docker.com/ | sh' "; exit 1; }

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
    docker save pull gcr.io/google_containers/pause > images/pause.tgz
fi
if [ ! -f images/cadvisor.tgz ];then 
    echo "Pulling cadvisor docker image...."
    docker pull google/cadvisor:latest
    echo "Saving cadvisor docker image...."
    docker save google/cadvisor > images/cadvisor.tgz
fi




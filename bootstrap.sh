#!/usr/bin/env sh

# Load Kubernetes docker images from the disk
docker load < /vagrant/etcd.tgz
docker load < /vagrant/hyperkube.tgz
docker load < /vagrant/pause.tgz

# Start Kubernetes docker contaoners
# etcd
docker run --net=host -d gcr.io/google_containers/etcd:2.0.9 /usr/local/bin/etcd --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data
# master
docker run --net=host -d -v /var/run/docker.sock:/var/run/docker.sock  gcr.io/google_containers/hyperkube:v1.0.1 /hyperkube kubelet --api_servers=http://127.0.0.1:8080 --v=2 --address=0.0.0.0 --enable_server --hostname_override=127.0.0.1 --config=/etc/kubernetes/manifests
# service proxy
docker run -d --net=host --privileged gcr.io/google_containers/hyperkube:v1.0.1 /hyperkube proxy --master=http://127.0.0.1:8080 --v=2


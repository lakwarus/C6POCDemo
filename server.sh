#!/bin/bash
	
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Linux machine
	# ----- Process the input command ----------------------------------------------
	args=""
	for c in $*
	do
    	if [ "$c" = "--debug" ] || [ "$c" = "-debug" ] || [ "$c" = "debug" ]; then
          	CMD="--debug"
          	continue
    	elif [ "$CMD" = "--debug" ]; then
          	if [ -z "$PORT" ]; then
                PORT=$c
          	fi
    	elif [ "$c" = "--stop" ] || [ "$c" = "-stop" ] || [ "$c" = "stop" ]; then
          	CMD="stop"
   		elif [ "$c" = "--start" ] || [ "$c" = "-start" ] || [ "$c" = "start" ]; then
          	CMD="start"
    	elif [ "$c" = "--version" ] || [ "$c" = "-version" ] || [ "$c" = "version" ]; then
          	CMD="version"
   		elif [ "$c" = "--restart" ] || [ "$c" = "-restart" ] || [ "$c" = "restart" ]; then
          	CMD="restart"
    	elif [ "$c" = "--test" ] || [ "$c" = "-test" ] || [ "$c" = "test" ]; then
          	CMD="test"
    	else
        	args="$args $c"
    	fi
	done

	case $CMD in
    start)
    	# Load Kubernetes docker images from the disk
	echo "Loading Kubernetes docker images....."
       	[ -f images/etcd.tgz ] && docker load < images/etcd.tgz
        [ -f images/hyperkube.tgz ] && docker load < images/hyperkube.tgz
        [ -f images/pause.tgz ] && docker load < images/pause.tgz
        [ -f images/cadvisor.tgz ] && docker load < images/cadvisor.tgz

        # Start Kubernetes docker contaoners
       	# etcd
	echo "Starting etcd....."
        docker run --net=host -d gcr.io/google_containers/etcd:2.0.9 /usr/local/bin/etcd --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data
        # master
	echo "Starting Kubernetes Mater....."
        docker run --net=host -d -v /var/run/docker.sock:/var/run/docker.sock gcr.io/google_containers/hyperkube:v1.0.1 /hyperkube kubelet --api_servers=http://127.0.0.1:8080 --v=2 --address=0.0.0.0 --enable_server --hostname_override=127.0.0.1 --config=/etc/kubernetes/manifests
       	# service proxy
	echo "Starting Kubernetes Service....."
        docker run -d --net=host --privileged gcr.io/google_containers/hyperkube:v1.0.1 /hyperkube proxy --master=http://127.0.0.1:8080 --v=2
	# run cAdvisor
	echo "Starting cAdvisor....."
	docker run   --volume=/:/rootfs:ro   --volume=/var/run:/var/run:rw   --volume=/sys:/sys:ro   --volume=/var/lib/docker/:/var/lib/docker:ro   --publish=4194:8080   --detach=true   --name=cadvisor   google/cadvisor:latest
	# run Carbon MT POC demo
	echo "Starting Carbon MT POC Demo..."

	;;
    stop)

	# Running down the cluster
	echo "stoping docker containers...."
	docker stop $(docker ps -a -q)
	echo "Removing docker containers...."
	docker rm $(docker ps -a -q)
	;;
    *)
        echo “Usage: $0 start\|stop”
        exit 1
	;;
    esac

elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    # setting up Kubernetes
    echo "Setting up Kubernetes v1.0.1"
    #vagrant up

elif [[ "$OSTYPE" == "cygwin" ]]; then
    # POSIX compatibility layer and Linux environment emulation for Windows
    echo "Setting up Kubernetes v1.0.1"
elif [[ "$OSTYPE" == "msys" ]]; then
    # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    echo "Setting up Kubernetes v1.0.1"
elif [[ "$OSTYPE" == "win32" ]]; then
    # I'm not sure this can happen.
    echo "Setting up Kubernetes v1.0.1"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
    # ...
    echo "Setting up Kubernetes v1.0.1"
else
    # Unknown.
    echo "Setting up Kubernetes v1.0.1"
fi


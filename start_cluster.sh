#!/bin/bash

# config vars
source config.sh
# Run etcd
#


docker run --net=host -d gcr.io/google_containers/etcd:2.2.1 /usr/local/bin/etcd --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data

# Run the master

docker run \
    --volume=/:/rootfs:ro \
    --volume=/sys:/sys:ro \
    --volume=/dev:/dev \
    --volume=/var/lib/docker/:/var/lib/docker:rw \
    --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
    --volume=/var/run:/var/run:rw \
    --net=host \
    --pid=host \
    --privileged=true \
    -d \
    justingrayston/hyperkube:$KUBE_VERSION \
    /hyperkube kubelet --api-servers=http://localhost:8080 --v=2 --address=0.0.0.0 --enable-server --hostname-override=127.0.0.1 --config=/etc/kubernetes/manifests-multi --cluster-dns=$DNS_SERVER_IP --cluster-domain=$DNS_DOMAIN


# Run the service proxy

docker run -d --net=host --privileged justingrayston/hyperkube:$KUBE_VERSION /hyperkube proxy --master=http://127.0.0.1:8080 --v=2

#!/bin/bash

# config vars
source config.sh
# Run etcd
#


#docker run --net=host -d gcr.io/google_containers/etcd:2.2.1 /usr/local/bin/etcd --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data

# Run the master

docker run \
    --volume=/:/rootfs:ro \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:rw \
    --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
    --volume=/var/run:/var/run:rw \
    --net=host \
    --pid=host \
    --privileged=true \
    --name=kubelet \
    -d \
    gcr.io/google_containers/hyperkube-amd64:${KUBE_VERSION} \
    /hyperkube kubelet \
        --containerized \
        --hostname-override="127.0.0.1" \
        --address="0.0.0.0" \
        --api-servers=http://localhost:8080 \
        --config=/etc/kubernetes/manifests \
        --cluster-dns=10.0.0.10 \
        --cluster-domain=cluster.local \
        --allow-privileged=true --v=2


# Run the service proxy

#docker run -d --net=host --privileged gcr.io/google_containers/hyperkube:$KUBE_VERSION /hyperkube proxy --master=http://127.0.0.1:8080 --v=2

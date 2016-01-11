#!/bin/bash

# Forward port 8080 (where the k8s API is server) on the docker vm to localhost:8080
# 
# This allows you to use kubectrl without passing in -s
# 
# You should only need to do this once, after you start the cluster.

machine=default

ssh -f -T -N -i ~/.docker/machine/machines/$machine/id_rsa docker@$(docker-machine ip $machine) \
	-L 8080:localhost:8080

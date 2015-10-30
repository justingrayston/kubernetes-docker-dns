#!/bin/bash

kubectl create -f dns/skydns-rc.yaml
kubectl create -f dns/skydns-svc.yaml

# DNS ResolvConfPath specified but does not exist. It could not be updated: /mnt/sda1/var/lib/docker/containers/037a6468246a658090b1276bd40d212f6d85d505760e04006e02fcd75a4e5eee/resolv.conf

#!/bin/bash
kubectl delete rc kube-dns-v9 --namespace=kube-system
kubectl delete svc kube-dns --namespace=kube-system
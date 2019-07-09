#!/bin/bash

helm del jenkins --purge
helm del my-nginx --purge

kubectl delete -f agent-replicaset-ssh.yaml --namespace jenkins

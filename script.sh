
#!/bin/bash

kubectl create namespace jenkins

echo helm init
helm init
 
cat <<- xx
###################
#     Jenkins.    #
###################
xx
helm install stable/jenkins --name jenkins -f helm/jenkins-values.yaml --namespace=jenkins
helm install stable/nginx-ingress --name my-nginx --set rbac.create=true --namespace=jenkins

kubectl scale --replicas=2 deployment/jenkins --namespace=jenkins

kubectl create -f agent-replicaset-ssh.yaml  --namespace=jenkins
kubectl scale --replicas=2 rs/jenkins-ssh-agent --namespace=jenkins

cat <<- xx
########################################################################################################################################
# It will take few minutes to get it up and running.   
# You can check status by following command:           
# kubectl get po --namespace=jenkins           
# Now use the following link to access Jenkins.        
#          http://localhost/jenkins       
# Jenkins admin password:
#  echo printf $(kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo         
########################################################################################################################################
xx

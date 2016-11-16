#!/bin/bash

#Choose a Project
oadm new-project logging --node-selector=""
oc project logging
#Create missing templates
oc apply -n openshift -f https://raw.githubusercontent.com/openshift/origin-aggregated-logging/master/deployer/deployer.yaml
#Create Supporting Service Accounts and Permissions
oc new-app logging-deployer-account-template
oadm policy add-cluster-role-to-user oauth-editor system:serviceaccount:logging:logging-deployer

oadm policy add-scc-to-user privileged system:serviceaccount:logging:aggregated-logging-fluentd
oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:logging:aggregated-logging-fluentd

oadm policy add-cluster-role-to-user rolebinding-reader system:serviceaccount:logging:aggregated-logging-elasticsearch
#load sequence configMap secret 
#configmap config
oc create configmap logging-deployer --from-literal kibana-hostname=kibana.logging.172.16.5.60.nip.io --from-literal public-master-url=https://master.openshift.vpclub.local:8443 --from-literal es-cluster-size=3

#Create Deployer Secret
oc new-app logging-deployer-template -p IMAGE_VERSION=v1.4.0-alpha.1 -p MODE=install




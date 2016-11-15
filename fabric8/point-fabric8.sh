#!/bin/bash
source log.sh
source clap.sh

gofabric8 deploy -y --version-console=2.2.190 --version-devops=2.3.60 --version-ipaas=2.2.190 --version-kubeflix=1.0.23 --version-zipkin=0.1.5 --namespace=fabric8 --domain=172.16.5.60.nip.io --pv=true --package=fabric8-platform-2.2.19-openshift.yml


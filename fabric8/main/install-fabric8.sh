#!/bin/bash
source ../../log.sh
source ../../clap.sh

echo $CMD_LINE
FABRIC8_OS=linux;
#FABRIC8_VERSION=$ver
GOFABRIC_SRC=/usr/local/bin/gofabric8
FABRIC8_SRC=fabric8-platform-2.2.28-openshift.yml
log 'migrate docker image first' 

#./exec-migrate-fabric8-2.1.19-image registry=$registry
if [ $? == 1 ]; then
  log 'please migrate docker image first,e.g. ./exec-migrate-fabric8-2.1.19-image registry=172.16.5.60:5000'
  exit 1
fi


if [ "" == "$ver" ]; then
  ver=0.4.105;
fi
log "download fabric8 binary"
if [ ! -f "$GOFABRIC_SRC" ]; then
  log "downloading gofabric client..."
  wget -O /usr/local/bin/gofabric8 https://github.com/fabric8io/gofabric8/releases/download/v$ver/gofabric8-$FABRIC8_OS-amd64; 
  chmod +x /usr/local/bin/gofabric8
fi

if [ ! -f "$FABRIC8_SRC" ]; then
  log "downloading package fabric8 ..."
  wget https://repo1.maven.org/maven2/io/fabric8/platform/packages/fabric8-platform/2.2.28/fabric8-platform-2.2.28-openshift.yml
fi
gofabric8 version

# svc.cluster.local
if [ "" == "$domain" ]; then
  log 'please specify domain=yourdomain, e.g. ./install-fabric8.sh domain=172.16.5.60.nip.io'
  exit
fi
log 'create project fabric8...'
oc new-project fabric8
log 'note that the nfs server ip is hard coded so far'
oc project fabric8

oc apply -f storage-pv-oc.yml
#specify version
log 'specify fabric8  version'
gofabric8 deploy -y  --namespace=fabric8 --domain=$domain --pv=true --package=$FABRIC8_SRC
#gofabric8 deploy -y --domain=$domain --pv=true
gofabric8 secrets -y
# add fabric8 registry anonymous privilege
oadm policy add-role-to-user system:image-puller system:anonymous -n fabric8

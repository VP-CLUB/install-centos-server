#!/bin/bash
env=oc
$env create -f service-account.yaml

$env create -f kibana-service.yaml
#confirm es-pv.yml nfs host frist
$env create -f es-pv.yml
$env create -f elasticsearch-logging.yaml

ELASTICSEARCH_HOST=$($env get svc elasticsearch -o template --template={{.spec.clusterIP}})
echo "host is $ELASTICSEARCH_HOST"
cp kibana-controller.yaml kibana-controller-actual.yaml
cp fluentd-daemonset.yaml fluentd-daemonset-actual.yaml
#replace
sed -i -- "s/\${ELASTICSEARCH_HOST}/${ELASTICSEARCH_HOST}/g" kibana-controller-actual.yaml
#kubectl create -f fluentd-es-logging-actual.yaml
$env create -f kibana-controller-actual.yaml
#use daemonset
sed -i -- "s/\${ELASTICSEARCH_HOST}/${ELASTICSEARCH_HOST}/g" fluentd-daemonset-actual.yaml
$env create -f fluentd-daemonset-actual.yaml
rm fluentd-daemonset-actual.yaml kibana-controller-actual.yaml

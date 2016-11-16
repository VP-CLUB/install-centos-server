#!/bin/bash
oc delete daemonset --all
oc delete all --all
oc delete template --all
oc delete serviceAccount --all
oc delete secret --all
oc delete oauthclient kibana-proxy
oc delete clusterrole --all

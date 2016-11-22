#!/bin/bash
env=oc
$env project fabric8
$env  create -f management.yml


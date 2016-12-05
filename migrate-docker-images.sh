#!/bin/bash

source "log.sh"
source "clap.sh"

dc=/usr/bin/docker

if [ "$config" == "" ]; then
  config=./config/docker-images
fi

filter_args=""
if [ "$filter" != "" ]; then
  filter_args="| grep $filter"
fi

if [ "$all" == "all" ]; then
  pull=pull
  tag=tag
  push=push
fi

cat $config $filter_args | { while read row; do

  image_name=$(echo $row | awk -v N=1 '{print $N}')
  image_id=$(echo $row | awk -v N=3 '{print $N}')
  image_tag=$(echo $row | awk -v N=2 '{print $N}')
  image_tag=${tag/\<none\>/}

  if [ "$image_tag" == "" ]; then
    image_full_name=$image_name
  else
    image_full_name=$image_name:$image_tag
  fi

  if [ "$pull" == "pull" ]; then
    proxychains4 $dc pull $image_full_name
    if [ "$only" == "only" ]; then
      continue
    fi
  fi

  if [ "$tag" == "tag" ]; then
    $dc tag $image_id $image_full_name 
    if [ "$only" == "only" ]; then
      continue
    fi
  fi

  if [ "$push" == "push" ]; then
    $dc push $image_full_name

    $dc rmi -f $image_full_name
    if [ "$only" == "only" ]; then
      continue
    fi
  fi


done }

log "Done"


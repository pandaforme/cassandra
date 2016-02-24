#!/usr/bin/env bash
cd $(dirname $0)
if [ -n $1 ];
then
  docker build -f ./Dockerfile$1 -t poklet/cassandra$1 .;
else
 docker build -t poklet/cassandra .;
fi


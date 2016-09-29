#!/bin/sh

echo "===> Building build image..."
docker build -t danielguerra/alpine-bro-build .

echo "===> Building bro..."
docker run --rm -ti \
       -v `pwd`:/source \
       danielguerra/alpine-bro-build

echo "===> Building bro image..."
cd final
docker build -t danielguerra/alpine-bro-build:fanout .

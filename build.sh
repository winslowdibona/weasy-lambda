#!/bin/sh

mkdir task
cp build_weasyprint.sh task
docker run -it -v $PWD/task:/var/task \
    -e LD_LIBRARY_PATH='/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib:/var/task/lib64:/opt/python:/opt/python/lib:/opt/python/lib64' \
    lambdalinux/baseimage-amzn /var/task/build_weasyprint.sh

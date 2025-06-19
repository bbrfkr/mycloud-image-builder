#!/bin/bash -xe
export DEBIAN_FRONTEND=noninteractive

# clean up
apt-get clean
rm -rf /var/lib/apt/lists/*
ls -1d /tmp/* | grep -v "/tmp/scripts" | xargs -I target rm -rf target

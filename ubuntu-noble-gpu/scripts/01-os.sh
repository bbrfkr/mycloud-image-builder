#!/bin/bash -xe
export DEBIAN_FRONTEND=noninteractive

# os update
apt-get update
apt-get -y upgrade

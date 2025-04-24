#!/bin/bash -xe
export DEBIAN_FRONTEND=noninteractive

# install latest ollama
curl -fsSL https://ollama.com/install.sh | sh

# disable service
systemctl disable --now ollama.service 
rm /etc/systemd/system/ollama.service

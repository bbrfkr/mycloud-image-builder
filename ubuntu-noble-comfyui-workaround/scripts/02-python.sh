#!/bin/bash -xe
export DEBIAN_FRONTEND=noninteractive

# install python (integrated os. necessary for sd webui)
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y wget git python3.11 python3.11-venv libgl1 libglib2.0-0
sudo python3.11 -m ensurepip

# install pip packages
sudo pip3 install huggingface-hub[cli]

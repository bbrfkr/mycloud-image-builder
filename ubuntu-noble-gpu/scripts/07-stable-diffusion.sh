#!/bin/bash -xe
export DEBIAN_FRONTEND=noninteractive

# clone source
cd /root
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui

# install dependencies
apt install -y wget git python3 python3-venv libgl1 libglib2.0-0

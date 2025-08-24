#!/bin/bash -xe
export DEBIAN_FRONTEND=noninteractive

# install pip packages for comfyui
sudo pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128
sudo pip3 install comfy-cli

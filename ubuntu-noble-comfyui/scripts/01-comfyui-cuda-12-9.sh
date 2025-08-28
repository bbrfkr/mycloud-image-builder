#!/bin/bash -xe
export DEBIAN_FRONTEND=noninteractive

# install pip packages for comfyui
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu129
pip install comfy-cli

#!/bin/bash -xe
export DEBIAN_FRONTEND=noninteractive

# clone source
cd /root
git clone https://github.com/bbrfkr/Hunyuan3D-2.git
cd Hunyuan3D-2
git checkout separate-devices

# enable pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# create venv
python -m venv venv
. venv/bin/activate

# install pytorch
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126

# install
pip install -r requirements.txt
pip install -e .

# deactivate
deactivate

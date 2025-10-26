#!/bin/bash -xe
export DEBIAN_FRONTEND=noninteractive

# install latest vllm
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pip install vllm[flashinfer] --extra-index-url https://download.pytorch.org/whl/cu129

# install latest ray
pip install "ray[default]"

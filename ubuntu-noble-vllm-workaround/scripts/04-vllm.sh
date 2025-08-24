#!/bin/bash -xe
export DEBIAN_FRONTEND=noninteractive

# install vllm
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu$(echo ${CUDA_VERSION} | tr -d -)
cd /root
git clone https://github.com/vllm-project/vllm.git
cd vllm
git checkout ${VLLM_COMMIT}
python use_existing_torch.py
pip install -r requirements/build.txt
pip install --no-build-isolation -e .

# install latest ray
pip install "ray[default]"

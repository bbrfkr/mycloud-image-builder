#!/bin/bash -xe
# execute by "ubuntu" user!
export DEBIAN_FRONTEND=noninteractive

# install nvidia driver
sudo apt update
sudo apt -y install nvidia-driver-${NVIDIA_DRIVER_VERSION}

# install cuda toolkit
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
rm -f cuda-keyring_1.0-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-${CUDA_VERSION}

# path setting
echo 'export PATH="/usr/local/cuda/bin:$PATH"' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"' >> ~/.bashrc

export DEBIAN_FRONTEND=noninteractive

# os update
apt -y update
apt -y upgrade

# install latest docker
apt-get -y install ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get -y update && apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# install nvidia driver
apt -y install nvidia-driver-${NVIDIA_DRIVER_VERSION}

# install cuda toolkit
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget -O cuda-repo.deb ${CUDA_REPO_URL}
dpkg -i cuda-repo.deb && rm -f cuda-repo.deb 
cp /var/cuda-repo-ubuntu2204-12-2-local/cuda-*-keyring.gpg /usr/share/keyrings/
apt-get update && apt-get -y install cuda

# install nvidia container driver
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg &&
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
apt -y update
apt install -y nvidia-container-toolkit
nvidia-ctk runtime configure --runtime=docker

# clean up
apt-get clean
rm -rf /var/lib/apt/lists/*
ls -1d /tmp/* | grep -v "/tmp/scripts" | xargs -I target rm -rf target


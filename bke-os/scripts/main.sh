export DEBIAN_FRONTEND=noninteractive

# os update
apt -y update
apt -y upgrade

# install jq, yj
apt -y install jq
wget -O /tmp/yj "https://github.com/sclevine/yj/releases/download/v5.1.0/yj-linux-amd64"
install -m 755 /tmp/yj /usr/local/bin/

# install containerd
wget -O /tmp/containerd-linux-amd64.tar.gz "https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz"
wget -O /tmp/containerd-linux-amd64.sha256sum "https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz.sha256sum"
CONTAINERD_TARBALL_SHA256=$(cat /tmp/containerd-linux-amd64.sha256sum | awk '{ print $1 }')
if ! echo "${CONTAINERD_TARBALL_SHA256} /tmp/containerd-linux-amd64.tar.gz" | sha256sum -c - ; then
    echo "ERROR containerd-linux-amd64.tar.gz computed checksum did NOT match, exiting."
    exit 1
fi
tar xzvf /tmp/containerd-linux-amd64.tar.gz -C /usr/local/ --no-same-owner --touch --no-same-permissions
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml

# install runc
wget -O /tmp/runc.amd64 "https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.amd64"
wget -O /tmp/runc.sha256sum "https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.sha256sum"
RUNC_TARBALL_SHA256=$(grep amd64 /tmp/runc.sha256sum | awk '{ print $1 }')
if ! echo "${RUNC_TARBALL_SHA256} /tmp/runc.amd64" | sha256sum -c - ; then
    echo "ERROR runc.amd64 computed checksum did NOT match, exiting."
    exit 1
fi
install -m 755 /tmp/runc.amd64 /usr/local/sbin/runc

# install cni
wget -O /tmp/cni-plugins-linux-amd64.tar.gz "https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-linux-amd64-v${CNI_PLUGINS_VERSION}.tgz"
wget -O /tmp/cni-plugins-linux-amd64.sha256sum "https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-linux-amd64-v${CNI_PLUGINS_VERSION}.tgz.sha256"
CNI_TARBALL_SHA256=$(cat /tmp/cni-plugins-linux-amd64.sha256sum | awk '{ print $1 }')
if ! echo "${CNI_TARBALL_SHA256} /tmp/cni-plugins-linux-amd64.tar.gz" | sha256sum -c - ; then
    echo "ERROR cni-plugins-linux-amd64.tar.gz computed checksum did NOT match, exiting."
    exit 1
fi
mkdir -p /opt/cni/bin
tar xzvf /tmp/cni-plugins-linux-amd64.tar.gz -C /opt/cni/bin/ --no-same-owner --touch --no-same-permissions

# install nerdctl
wget -O /tmp/nerdctl-linux-amd64.tar.gz https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-amd64.tar.gz
wget -O /tmp/nerdctl-linux-amd64.sha256 https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/SHA256SUMS
NERDCTL_TARBALL_SHA256=$(grep -e linux-amd64 /tmp/nerdctl-linux-amd64.sha256 | grep -v full | awk '{ print $1 }')
if ! echo "${NERDCTL_TARBALL_SHA256} /tmp/nerdctl-linux-amd64.tar.gz" | sha256sum -c - ; then
    echo "ERROR nerdctl-linux-amd64.tar.gz computed checksum did NOT match, exiting."
    exit 1
fi
tar xvfz /tmp/nerdctl-linux-amd64.tar.gz -C /usr/local/bin/

# clean up
apt-get clean
rm -rf /var/lib/apt/lists/*
ls -1d /tmp/* | grep -v "/tmp/scripts" | xargs -I target rm -rf target

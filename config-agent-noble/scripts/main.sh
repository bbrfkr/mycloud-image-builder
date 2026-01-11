export DEBIAN_FRONTEND=noninteractive

# os update
apt-get -y update
apt-get -y upgrade

# install config agent via apt-get
apt-get -y install python3-os-collect-config python3-os-apply-config python3-os-refresh-config

# configure config agent
bash /tmp/scripts/configure_config_agent.sh

# start config agent
bash /tmp/scripts/start_config_agent.sh

# clean up
apt-get clean
rm -rf /var/lib/apt/lists/*
ls -1d /tmp/* | grep -v "/tmp/scripts" | xargs -I target rm -rf target

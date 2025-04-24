export DEBIAN_FRONTEND=noninteractive

# os update
apt -y update
apt -y upgrade

# install python build env
apt-get -y install python3-pip

# install config agent by pip
pip3 install os-collect-config os-apply-config os-refresh-config

# configure config agent
bash /tmp/scripts/configure_config_agent.sh

# start config agent
bash /tmp/scripts/start_config_agent.sh

# clean up
apt-get clean
rm -rf /var/lib/apt/lists/*
ls -1d /tmp/* | grep -v "/tmp/scripts" | xargs -I target rm -rf target

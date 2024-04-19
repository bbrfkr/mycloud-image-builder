#!/bin/bash
set -eux

# os-apply-config templates directory
oac_templates=/usr/libexec/os-apply-config/templates
mkdir -p $oac_templates/etc

# initial /etc/os-collect-config.conf
cat <<EOF >/etc/os-collect-config.conf
[DEFAULT]
command = os-refresh-config
EOF

# template for building os-collect-config.conf for polling heat
cat /tmp/scripts/os-collect-config.conf > $oac_templates/etc/os-collect-config.conf
mkdir -p $oac_templates/var/run/heat-config

# template for writing heat deployments data to a file
echo "{{deployments}}" > $oac_templates/var/run/heat-config/heat-config

# os-refresh-config scripts directory.
# For older version, this path might be `/opt/stack/os-config-refresh`
orc_scripts=/usr/libexec/os-refresh-config
for d in pre-configure.d configure.d migration.d post-configure.d; do
    install -m 0755 -o root -g root -d $orc_scripts/$d
done

# os-refresh-config script for running os-apply-config
cat /tmp/scripts/20-os-apply-config > $orc_scripts/configure.d/20-os-apply-config
chmod 700 $orc_scripts/configure.d/20-os-apply-config

# os-refresh-config script for running heat config hooks
cat /tmp/scripts/55-heat-config > $orc_scripts/configure.d/55-heat-config
chmod 700 $orc_scripts/configure.d/55-heat-config

# config hook for shell scripts
hooks_dir=/var/lib/heat-config/hooks
mkdir -p $hooks_dir

# install hook for configuring with shell scripts
cat /tmp/scripts/hook-script.py >$hooks_dir/script
chmod 755 $hooks_dir/script

# install heat-config-notify command
cat /tmp/scripts/heat-config-notify > /usr/bin/heat-config-notify
chmod 755 /usr/bin/heat-config-notify

# run once to write out /etc/os-collect-config.conf
os-collect-config --one-time --debug
cat /etc/os-collect-config.conf

# run again to poll for deployments and run hooks
os-collect-config --one-time --debug

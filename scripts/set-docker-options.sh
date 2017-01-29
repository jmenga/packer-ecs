#!/usr/bin/env bash
set -e

# Remove the default Docker bridge
# This will require all containers on the host to run in host networking mode
echo "### Removing Docker bridge for host networking mode ###"
sudo sed -i -e "s|^\(OPTIONS=\".*\)\"$|\1 --bridge=none --ip-forward=false --ip-masq=false --iptables=false\"|" \
  /etc/sysconfig/docker

# Stop Docker service
sudo service docker stop

# Remove Docker network database
sudo rm -rf /var/lib/docker/network

# Remove docker0 interface if it has been created
sudo ip link del docker0 || true
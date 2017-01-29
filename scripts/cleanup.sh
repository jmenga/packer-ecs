#!/usr/bin/env bash
set -e

echo "### Performing final clean-up tasks ###"
sudo service docker stop
sudo chkconfig docker off
sudo rm -f /var/log/docker /var/log/ecs/*
# An intermittent failure scenario sees this created as a directory when the
# ECS agent attempts to map it into its container, so do rm -Rf just in case
sudo rm -Rf /var/run/docker.sock
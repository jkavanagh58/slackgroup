#!/bin/bash
echo "UPDATING SYSTEM SOFTWARE – UPDATE"
apt-get update
echo "UPDATING SYSTEM SOFTWARE – UPGRADE"
apt-get -y upgrade
echo "UPDATING SYSTEM SOFTWARE – DISTRIBUTION"
apt-get -y dist-upgrade
echo "REMOVING APPLICATION ORPHANS"
apt-get autoremove –purge
echo "UPDATING FIRMWARE"
rpi-update
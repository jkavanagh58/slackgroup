#!/bin/bash
echo "UPDATING SYSTEM SOFTWARE – UPDATE"
apt-get update
echo "UPDATING SYSTEM SOFTWARE – UPGRADE"
apt-get upgrade
echo "UPDATING SYSTEM SOFTWARE – DISTRIBUTION"
apt-get dist-upgrade
echo "REMOVING APPLICATION ORPHANS"
apt-get autoremove –purge
echo "UPDATING FIRMWARE"
rpi-update
#!/bin/bash

###########################
# Workaround for Dungeon defender Eternity on linux
#
# Author : José Gonçalves
###########################

DUNDEFPATH=".steam/steam/SteamApps/common/DunDefEternity/DunDefEternityLauncher"

## Check for unavailble libs :
echo "Checking for unavailable libs..."
unlib=`ldd $DUNDEFPATH | grep "not found" | tr "\t" " " | cut -d"=" -f1`
echo $unlib
echo ""

## Check for available libs :
echo "Checking for available libs..."
avlib=`ldd $DUNDEFPATH | grep lib  | tr "\t" " " | cut -d"=" -f1`
echo $avlib
echo ""

# Installing Main libs
## activation of i386 arch
echo "Add i386 arch"
sudo dpkg-add-architecture i386

echo "Installing missing libs :"
sudo apt-get install -y libsfm-dev:i386 libcrypto++-dev:i386 libcurl4-nss-dev:i386 libcurl4-openssl-dev:i386 libfreetype6:i386 libxrandr2:i386 libgtk2.0-0:i386 libpango-1.0-0:i386 libpangocairo-1.0-0:i386 libasound2-dev:i386 libgdk-pixbuf2.0-0:i386
echo ""

echo "Checking unavailable libs (If you have nothing is good :))"
echo `ldd $DUNDEFPATH | grep "not found" | tr "\t" " " | cut -d"=" -f1`
echo ""


echo "# ATTENTION : ##############################################################" 
echo "# If OpenGL is no more supported, please reinstall your NVIDIA/ATI Drivers #"
echo "############################################################################"

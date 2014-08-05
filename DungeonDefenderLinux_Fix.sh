#!/bin/bash

###########################
# Workaround for Dungeon defender Eternity on linux
###########################

# SET PATH :
## Dungeaon defender launcher path 
DUNDEFPATH="$HOME/.steam/steam/SteamApps/common/DunDefEternity/DunDefEternityLauncher"
## Steam libs path
STEAMPATH="$HOME/.steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/*"
## Dnndef Binaries path
DUNDEFPATHLINK="$HOME/.steam/steam/SteamApps/common/DunDefEternity/DunDefEternity/Binaries/Linux/"

function cleaning {
	unset DUNDEFPATH 
	unset DUNDEFPATHLINK
	unset STEAMPATH
	unset unlib
	unset avlib
	unset choice
}

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

while true; do
	echo "What workaround do you want?"
	echo " 1 - Symlink way (Work on Redhat/Fedora and Debian/Ubuntu) "
	echo " 2 - Installing package way (Works on Debian/Ubuntu 64 bit) "
	echo " Q - Quit"
	echo -e "Your choice : "
	read choice

	case $choice in 
		1)
			ln -sf $STEAMPATH $DUNDEFPATHLINK
			clear;
			echo "Symlink Done!"
			echo "#################################################"
			echo "# Try to launch Dungeon Defender Steam	      #"
			echo "#################################################"
			cleaning
			exit 0;
			;;
		2)
			# Installing Main libs
			## activation of i386 arch
			echo "Add i386 arch"
			sudo dpkg --add-architecture i386
			
			echo "Installing missing libs :"
			sudo aptitude install -y libsfml-dev:i386 libcrypto++-dev:i386 libcurl4-nss-dev:i386 libcurl4-openssl-dev:i386 libfreetype6:i386 libxrandr2:i386 libgtk2.0-0:i386 libpango-1.0-0:i386 libpangocairo-1.0-0:i386 libasound2-dev:i386 libgdk-pixbuf2.0-0:i386
			echo ""
			
			echo "Checking unavailable libs (If you have nothing is good :))"
			echo `ldd $DUNDEFPATH | grep "not found" | tr "\t" " " | cut -d"=" -f1`
			echo ""
			
			echo "# ATTENTION : ##############################################################" 
			echo "# If OpenGL is no more supported, please reinstall your NVIDIA/ATI Drivers #"
			echo "############################################################################"
			cleaning
			exit 0;
			;;
		Q|q)
			cleaning
			exit 0;	
			;;
		*)
			echo "Please choose somthing available on the list..."
			;;
	esac
done

exit 0;

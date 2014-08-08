#!/bin/bash
###########################
# Workaround for Dungeon defender Eternity on linux
# --------------------------------------------------
# Big thanks for the community arround Valve!
# Thanks for your feedback, reports...
###########################

# SET PATH :
## Is not an Edge Fix ;) PATH : (Default path for SteamOS)
EDGE_DUNDEFPATH=""
EDGE_STEAMPATH=""
EDGE_DUNDEFPATHLINK=""

## Panda's fix PATH : (Default path for Ubuntu)
PANDA_DUNDEFPATH="$HOME/.steam/steam/SteamApps/common/DunDefEternity/DunDefEternityLauncher"
PANDA_STEAMPATH="$HOME/.steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/*"
PANDA_DUNDEFPATHLINK="$HOME/.steam/steam/SteamApps/common/DunDefEternity/DunDefEternity/Binaries/Linux/"

## Adrian Fix specials paths : (Default path for ArchLinux (not sure, need to install an Archlinux when i can... to do some test))
ADRIAN_GLIBPATH="$HOME/.local/share/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libdbus-glib-1.so.2"
ADRIAN_GCONFPATH="$HOME/.local/share/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libgconf-2.so.4"
ADRIAN_DUNDEFPATHARCH="/opt/games/steam/SteamApps/common/DunDefEternity/DunDefEternity/Binaries/Linux"

function cleaning {

    unset PANDA_DUNDEFPATH
    unset PANDA_DUNDEFPATHLINK
    unset PANDA_STEAMPATH

    unset ADRIAN_GLIBPATH
    unset ADRIAN_GCONFPATH
    unset ADRIAN_DUNDEFPATHARCH

    unset unlib
    unset avlib
    unset choice
}

function CheckLibs {
    ## Check for available libs :
    echo "Checking for available libs..."
    avlib=`ldd ${DUNDEFPATH} | grep lib  | tr "\t" " " | cut -d"=" -f1`
    echo ${avlib}
    echo ""

    echo "Checking for unavailable libs..."
    unlib=`ldd ${DUNDEFPATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo ${unlib}
    echo ""
}

function EdgeFix {
    ln -sf ${STEAMPATH} ${DUNDEFPATHLINK}
    clear;
    echo "Symlink Done!"
    echo "#################################################"
    echo "# Try to launch Dungeon Defender Steam	      #"
    echo "#################################################"
}

function PandaFix {
    # Installing Main libs
    ## activation of i386 arch
    echo "Add i386 arch"
    sudo dpkg --add-architecture i386

    echo "Installing missing libs :"
    sudo aptitude install -y libgconf-2-4:i386 libvorbisfile3:i386 libsfml-dev:i386 libcrypto++-dev:i386 libcurl4-nss-dev:i386 libcurl4-openssl-dev:i386 libfreetype6:i386 libxrandr2:i386 libgtk2.0-0:i386 libpango-1.0-0:i386 libpangocairo-1.0-0:i386 libasound2-dev:i386 libgdk-pixbuf2.0-0:i386
    echo ""

    echo "Checking unavailable libs (If you have nothing is good :))"
    echo `ldd ${DUNDEFPATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo ""

    echo "# ATTENTION : ##############################################################"
    echo "# If OpenGL is no more supported, please reinstall your NVIDIA/ATI Drivers #"
    echo "############################################################################"
}

function AdrianFix {
    ln -sf ${ADRIAN_GLIBPATH} ${ADRIAN_DUNDEFPATHARCH}
    ln -sf ${ADRIAN_GCONFPATH} ${ADRIAN_DUNDEFPATHARCH}
    LD_PRELOAD=/usr/lib32/libudev.so.0 %command%
}

## Scan your libs :
CheckLibs

while true; do
    echo "What workaround do you want?"
    echo "----------------------------"
    echo " 1 - Edge Fix --> Symlink way (Work on Redhat/Fedora and Debian/Ubuntu)"
    echo " 2 - PandaWan Fix --> Package way (Work on Debian/Ubuntu 64 bit) "
    echo " 3 - Adrian Fix --> Symlink way (Seems work on ArchLinux)"
    echo " Q - Quit"
    echo "------------------------------------------"
    echo -e "Your choice : "
    read choice

    case ${choice} in
        1)
            EdgeFix
            cleaning
            exit 0;
            ;;
        2)
            PandaFix
            cleaning
            exit 0;
            ;;
        3)
            AdrianFix
            cleaning
            exit 0;
            ;;
        Q|q)
            cleaning
            exit 0;
            ;;
        *)
            echo "Please choose something available on the list..."
            ;;
    esac
done

exit 0;
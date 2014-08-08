#!/bin/bash
###########################
# Workaround for Dungeon defender Eternity on linux
# --------------------------------------------------
# Big thanks for the community arround Valve!
# Thanks for your feedback, reports...
###########################

# SET PATH :
## Is not an Edge Fix ;) PATH : (Default path for SteamOS)
EDGE_DUNDEFPATH="/usr/local/games/Steam/SteamApps/common/DunDefEternity/DunDefEternityLauncher"
EDGE_STEAMPATH="/usr/local/games/Steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/*"
EDGE_DUNDEFPATHLINK="/usr/local/games/Steam/SteamApps/common/DunDefEternity/DunDefEternity/Binaries/Linux/"

## Panda's fix PATH : (Default path for Ubuntu)
PANDA_DUNDEFPATH="$HOME/.steam/steam/SteamApps/common/DunDefEternity/DunDefEternityLauncher"
PANDA_STEAMPATH="$HOME/.steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/*"
PANDA_DUNDEFPATHLINK="$HOME/.steam/steam/SteamApps/common/DunDefEternity/DunDefEternity/Binaries/Linux/"

## Adrian Fix specials paths : (Default path for ArchLinux (not sure, need to install an Archlinux when i can... to do some test))
ADRIAN_DUNDEFLAUNCHER="/opt/games/steam/SteamApps/common/DunDefEternity/DunDefEternityLauncher"
ADRIAN_GLIBPATH="$HOME/.local/share/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libdbus-glib-1.so.2"
ADRIAN_GCONFPATH="$HOME/.local/share/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libgconf-2.so.4"
ADRIAN_DUNDEFPATHARCH="/opt/games/steam/SteamApps/common/DunDefEternity/DunDefEternity/Binaries/Linux"

# Not an Edge Fix this workaround seems work well on SteamOS linux flavour.
function Not_An_EdgeFix {
    ## Check for available libs :
    echo "Checking for available libs..."
    avlib=`ldd ${EDGE_DUNDEFPATH} | grep lib  | tr "\t" " " | cut -d"=" -f1`
    echo ${avlib}
    echo ""

    echo "Checking for unavailable libs..."
    unlib=`ldd ${EDGE_DUNDEFPATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo ${unlib}
    echo ""

    ## Doing job
    ln -sf ${EDGE_STEAMPATH} ${EDGE_DUNDEFPATHLINK}
    clear;
    echo "Symlink Done!"


    ## Cleaing
    unset EDGE_DUNDEFPATH
    unset EDGE_STEAMPATH
    unset EDGE_DUNDEFPATHLINK
    unset avlib
    unset unlib
}

# PandaFix workaround (For Debian/Ubuntu/Kubuntu etc... ) install the package needed and afterwards the libs are provided
# by LD path :). To check your LD path ldconfig -v
function PandaFix {
    ## Check for available libs :
    echo "Checking for available libs..."
    avlib=`ldd ${PANDA_DUNDEFPATH} | grep lib  | tr "\t" " " | cut -d"=" -f1`
    echo ${avlib}
    echo ""

    ## Check for unavailable libs :
    echo "Checking for unavailable libs..."
    unlib=`ldd ${PANDA_DUNDEFPATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo ${unlib}
    echo ""

    # Installing Main libs
    ## activation of i386 arch
    echo "Add i386 arch"
    sudo dpkg --add-architecture i386

    echo "Installing missing libs :"
    sudo aptitude install -y libgconf-2-4:i386 libvorbisfile3:i386 libsfml-dev:i386 libcrypto++-dev:i386 libcurl4-nss-dev:i386 libcurl4-openssl-dev:i386 libfreetype6:i386 libxrandr2:i386 libgtk2.0-0:i386 libpango-1.0-0:i386 libpangocairo-1.0-0:i386 libasound2-dev:i386 libgdk-pixbuf2.0-0:i386
    echo ""

    echo "Checking unavailable libs (If you have nothing is good :))"
    echo `ldd ${PANDA_DUNDEFPATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo ""

    echo "# ATTENTION : ##############################################################"
    echo "# If OpenGL is no more supported, please reinstall your NVIDIA/ATI Drivers #"
    echo "############################################################################"

    # Cleaning
    unset PANDA_DUNDEFPATH
    unset unlib
    unset avlib

}

function AdrianFix {
    ## Check for available libs :
    echo "Checking for available libs..."
    avlib=`ldd ${ADRIAN_DUNDEFLAUNCHER} | grep lib  | tr "\t" " " | cut -d"=" -f1`
    echo ${avlib}
    echo ""

    echo "Checking for unavailable libs..."
    unlib=`ldd ${ADRIAN_DUNDEFLAUNCHER} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo ${unlib}
    echo ""

    ln -sf ${ADRIAN_GLIBPATH} ${ADRIAN_DUNDEFPATHARCH}
    ln -sf ${ADRIAN_GCONFPATH} ${ADRIAN_DUNDEFPATHARCH}
    LD_PRELOAD=/usr/lib32/libudev.so.0 ${ADRIAN_DUNDEFLAUNCHER}
    echo "Symlink done!"

    # Cleaning before exit!
    unset ADRIAN_GLIBPATH
    unset ADRIAN_GCONFPATH
    unset ADRIAN_DUNDEFPATHARCH
    unset ADRIAN_DUNDEFLAUNCHER
    unset ${avlib}
    unset ${unlib}
}

## Scan your libs :
CheckLibs

while true; do
    echo "What workaround do you want?"
    echo "----------------------------"
    echo " 1 - Is not an Edge Fix --> Symlink way (Work on Redhat/Fedora and Debian/Ubuntu)"
    echo " 2 - PandaWan Fix --> Package way (Work on Debian/Ubuntu 64 bit) "
    echo " 3 - Adrian Fix --> Symlink way (Seems work on ArchLinux)"
    echo " 4 - Check where yours Libs are"
    echo " Q - Quit"
    echo "------------------------------------------"
    echo -e "Your choice : "
    read choice

    case ${choice} in
        1)
            Not_An_EdgeFix
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
            exit 0;
            ;;
        4)
            ldconfig -v | less
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

    # Cleaning
    unset choice
done

exit 0;
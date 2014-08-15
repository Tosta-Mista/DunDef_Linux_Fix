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

## Adrian Fix specials paths : (Default path for ArchLinux (not sure, need to install an Archlinux when i can... to do some test))
ADRIAN_DUNDEFLAUNCHER="/opt/games/steam/SteamApps/common/DunDefEternity/DunDefEternityLauncher"
ADRIAN_GLIBPATH="$HOME/.local/share/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libdbus-glib-1.so.2"
ADRIAN_GCONFPATH="$HOME/.local/share/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libgconf-2.so.4"
ADRIAN_DUNDEFPATHARCH="/opt/games/steam/SteamApps/common/DunDefEternity/DunDefEternity/Binaries/Linux"

# Function used to ask if the user want to launch the game :
function GameLaunch {
    local step=true
    while ${step}; do
        echo -e "Do you want launch Dungeon Defender?(Y/N)"
        read answer
        case ${answer} in
            Y|y)
                steam steam://rungameid/302270 &
                step=false
                ;;
            N|n)
                echo "Quiting..."
                step=false
                ;;
            *)
                echo "Please use Y or N."
                step=true
                ;;
        esac
    done
}

# Not an Edge Fix this workaround seems work well on SteamOS linux flavour.
function Not_An_EdgeFix {
    ## Check for available libs :
    echo "Checking for available libs..."
    echo `ldd ${EDGE_DUNDEFPATH} | grep lib  | tr "\t" " " | cut -d"=" -f1`
    echo ""

    echo "Checking for unavailable libs..."
    echo `ldd ${EDGE_DUNDEFPATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo ""

    ## Doing job
    ln -sf ${EDGE_STEAMPATH} ${EDGE_DUNDEFPATHLINK}
    clear;
    echo "Symlinking Done!"
}

# PandaFix workaround (For Debian/Ubuntu/Kubuntu etc... ) install the package needed and afterwards the libs are provided
# by LD path :). To check your LD path ldconfig -v
function PandaFix {
    ## Check for available libs :
    echo "Checking for available libs..."
    echo `ldd ${PANDA_DUNDEFPATH} | grep lib  | tr "\t" " " | cut -d"=" -f1`
    echo ""

    ## Check for unavailable libs :
    echo "Checking for unavailable libs..."
    echo `ldd ${PANDA_DUNDEFPATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo ""

    echo "Directories used for your libs"
    # Prints out all directory used to provide your libs
    sudo ldconfig -v 2>/dev/null | grep -v ^$'\t'

    # Installing Main libs
    ## Debian
    if [[ -x "$(which aptitude)" ]]; then
        echo "Add i386 arch"
        sudo dpkg --add-architecture i386

        echo "Installing missing libs :"
        sudo aptitude install libgconf-2-4:i386 libvorbisfile3:i386 libsfml-dev:i386 \
            libcrypto++-dev:i386 libcurl4-nss-dev:i386 libcurl4-openssl-dev:i386 libfreetype6:i386 \
            libxrandr2:i386 libgtk2.0-0:i386 libpango-1.0-0:i386 libpangocairo-1.0-0:i386 libasound2-dev:i386 \
            libgdk-pixbuf2.0-0:i386
    fi

    ## Red Hat
    if [[ -x "$(which yum)" ]]; then
        echo "Installing missing libs :"
        sudo yum install GConf2.i686 GConf2-devel.i686 libvorbis.i686 SFML.i686 SFML-devel.i686 \
            cryptopp.i686 libcurl.i686 libcurl-devel.i686 freetype.i686 freetype-devel.i686 libXrandr.i686 \
            libXrandr-devel.i686 gtk2.i686 gtk2-devel.i686 pango.i686 pango-devel.i686 cairo.i686 \
            cairo-devel.i686 gfk-pixbuf2-devel.i686 gtk-pixbuf2.i686
    fi

    ## ArchLinux
    if [[ -x "$(which pacman)" ]]; then
        echo "Installing missing libs :"
        echo "Pacman is currently not supported"
        #sudo pacman -S
    fi

    echo ""
    echo "Checking unavailable libs (If you have nothing then you're good :))"
    echo `ldd ${PANDA_DUNDEFPATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo ""

    echo "# ATTENTION : ################################################################"
    echo "# If OpenGL is no longer supported, please reinstall your NVIDIA/ATI Drivers #"
    echo "##############################################################################"
}

# Adrian Workaround another symlink way for Archlinux Install (maybe other flavours) not tested yet ...
function AdrianFix {
    ## Check for available libs :
    echo "Checking for available libs..."
    echo `ldd ${ADRIAN_DUNDEFLAUNCHER} | grep lib  | tr "\t" " " | cut -d"=" -f1`
    echo ""

    echo "Checking for unavailable libs..."
    echo `ldd ${ADRIAN_DUNDEFLAUNCHER} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo ""

    ln -sf ${ADRIAN_GLIBPATH} ${ADRIAN_DUNDEFPATHARCH}
    ln -sf ${ADRIAN_GCONFPATH} ${ADRIAN_DUNDEFPATHARCH}
    # LD_PRELOAD=/usr/lib32/libudev.so.0 ${ADRIAN_DUNDEFLAUNCHER} ## Removed need to test that...
    echo "Symlinking done!"
}

#Show menu :
while true; do
    echo "------------------------"
    echo "Choose your workaround :"
    echo "------------------------"
    echo " 1 - Is not an Edge Fix --> Symlink way (Works on Redhat/Fedora and Debian/Ubuntu)"
    echo " 2 - PandaWan Fix --> Package way (Works on Debian/Ubuntu 64 bit) "
    echo " 3 - Adrian Fix --> Symlink way (Seems to work on ArchLinux)"
    echo " 4 - Show all directories used to provide your Libs"
    echo " Q - Quit"
    echo "------------------------------------------"
    echo "Your choice : "
    read choice

    case ${choice} in
        1)
            Not_An_EdgeFix
            GameLaunch
            exit 0;
            ;;
        2)
            PandaFix
            GameLaunch
            exit 0;
            ;;
        3)
            AdrianFix
            GameLaunch
            exit 0;
            ;;
        4)
            # Prints out all directory used to provide your libs
            sudo ldconfig -v 2>/dev/null | grep -v ^$'\t'
            exit 0;
            ;;
        Q|q)
            exit 0;
            ;;
        *)
            echo "Please choose something available on the list..."
            ;;
    esac
done

#!/bin/bash
###########################
# Workaround for Dungeon defender Eternity on linux
# --------------------------------------------------
# Big thanks for the community arround Valve!
# Thanks for your feedback, reports...
###########################

# SET PATH :
STEAMPATH=`locate "steam.pid" | head -1 | awk '{ sub("/[a-z]*.[a-z]*.$", ""); print }'`
STEAM_LIB_PATH=`locate "steam.pid" | head -1 | awk '{ sub("/[a-z]*.[a-z]*.$", "/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/*"); print }'`
DUNDEF_LIB_PATH=`locate "steam.pid" | head -1 | awk '{sub("/[a-z]*.[a-z]*.$", "/steam/SteamApps/common/DunDefEternity/DunDefEternity/Binaries/Linux/"); print }'`
DUNDEF_LAUNCHER_PATH=`locate "steam.pid" | head -1 | awk '{ sub("/[a-z]*.[a-z]*.$", "/steam/SteamApps/common/DunDefEternity/DunDefEternityLauncher"); print }'`

apt="libgconf-2-4:i386 libvorbisfile3:i386 libsfml-dev:i386 libcrypto++-dev:i386 libcurl4-nss-dev:i386 \
    libcurl4-openssl-dev:i386 libfreetype6:i386 libxrandr2:i386 libgtk2.0-0:i386 libpango-1.0-0:i386 \
    libpangocairo-1.0-0:i386 libasound2-dev:i386 libgdk-pixbuf2.0-0:i386"
yum="GConf2.i686 GConf2-devel.i686 libvorbis.i686 SFML.i686 SFML-devel.i686 cryptopp.i686 libcurl.i686 \
    libcurl-devel.i686 freetype.i686 freetype-devel.i686 libXrandr.i686 libXrandr-devel.i686 gtk2.i686 \
    gtk2-devel.i686 pango.i686 pango-devel.i686 cairo.i686 cairo-devel.i686 gfk-pixbuf2-devel.i686 \
    gtk-pixbuf2.i686"
pacman=""


# Function used to ask if the user want to launch the game :
function GameLaunch () {
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

function CheckLibs () {
    ## Check for available libs :
    echo "Checking for available libs..."
    echo `ldd ${DUNDEF_LAUNCHER_PATH} | grep lib  | tr "\t" " " | cut -d"=" -f1`
    echo ""

    ## Check for unavailable libs :
    echo "Checking for unavailable libs..."
    echo `ldd ${DUNDEF_LAUNCHER_PATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo ""

    echo "Directories used for your libs"
    # Prints out all directory used to provide your libs
    sudo ldconfig -v 2>/dev/null | grep -v ^$'\t'
}

# Not an Edge Fix this workaround seems work well on SteamOS linux flavour.
function SymLinkFix () {
    ## Check for available libs :
    echo "Checking for available libs..."
    echo `ldd ${DUNDEF_LAUNCHER_PATH} | grep lib  | tr "\t" " " | cut -d"=" -f1`
    echo ""

    echo "Checking for unavailable libs..."
    echo `ldd ${DUNDEF_LAUNCHER_PATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo ""

    ## Doing job
    ln -sf ${STEAM_LIB_PATH} ${DUNDEF_LIB_PATH}
    clear;
    echo "Symlinking Done!"
}

# PandaFix workaround (For Debian/Ubuntu/Kubuntu etc... ) install the package needed and afterwards the libs are provided
# by LD path :). To check your LD path ldconfig -v
function PandaFix {
    CheckLibs

    # Installing Main libs
    ## Debian
    if [[ -x "$(which aptitude)" ]]; then
        echo "Add i386 arch"
        sudo dpkg --add-architecture i386

        echo "Installing missing libs :"
        sudo aptitude install $apt

    elif [[ -x "$(which apt-get)" ]]; then
        echo "Add i386 arch"
        sudo dpkg --add-architecture i386

        echo "Installing missing libs :"
        sudo apt-get install $apt
    fi

    ## Red Hat
    if [[ -x "$(which yum)" ]]; then
        echo "Installing missing libs :"
        sudo yum install $yum
    fi

    ## ArchLinux
    if [[ -x "$(which pacman)" ]]; then
        echo "Installing missing libs :"
        echo "Pacman is currently not supported"
        #sudo pacman -S $pacman
    fi

    echo ""
    echo "Checking unavailable libs (If you have nothing then you're good :))"
    echo `ldd ${DUNDEF_LAUNCHER_PATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo ""

    echo "# ATTENTION : ################################################################"
    echo "# If OpenGL is no longer supported, please reinstall your NVIDIA/ATI Drivers #"
    echo "##############################################################################"
}

Cleaning () {
    echo "Cleaning symlink fix..."
    find "$DUNDEF_LIB_PATH" -maxdepth 1 -type l -exec rm -f {} \;
    echo "Cleaning done..."
}

#Show menu :
while true; do
    echo "----------------------------"
    echo "-[ Choose your workaround ]-"
    echo "----------------------------"
    echo " [1] -> SymLink Fix   --> Create all symlinks needed to fix your issue. (All Linux OS)"
    echo " [2] -> PandaWan Fix  --> Install all package needed for your game. (Apt/Yum manager only.)"
    echo " [3] -> ShowMyLibs    --> Show all directories used to provide your Libs (All linux OS)"
    echo " [4] -> Cleaning      --> Remove Symlink Fix!"
    echo " [Q] -> Quit"
    echo "---------------------------"
    echo "Your choice : "
    read choice

    case ${choice} in
        1)
            SymLinkFix
            GameLaunch
            exit 0;
            ;;
        2)
            PandaFix
            GameLaunch
            exit 0;
            ;;
        3)
            # Prints out all directories used to provide your libs
            CheckLibs
            ;;
        4)
            Cleaning
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

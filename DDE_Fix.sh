#!/bin/bash
###########################
# Workaround for Dungeon defender Eternity on linux
# --------------------------------------------------
# Big thanks for the community arround Valve!
# Thanks for your feedback, reports...
###########################
# Bash Trap commmand
trap bashtrap INT

purple='\e[0;35m'
yellow='\e[1;33m'
red='\e[1;31m'
nc='\e[0m'

# Update your locate
echo -e "${red}Settings up PATHS...${nc}"

# SET PATH :
STEAMPATH=$(find / -name "steam.pipe" 2>/dev/null | head -1 | sed "s/\/steam\.pipe/\//")
STEAM_LIB_PATH=$(find / -name "steam-runtime" 2>/dev/null | head -1)/i386
STEAMAPPS=$(find / -name "SteamApps" 2>/dev/null | head -1)
# In case of the game path is not the default path :
DUNDEF_LIB_PATH=$(find / -name "DunDefEternity" 2>/dev/null | head -1)/DunDefEternity/Binaries/Linux
DUNDEF_LAUNCHER_PATH=$(find / -name "DunDefEternityLauncher" 2>/dev/null | head -1)

# List of package used for Debian :
apt="libgconf-2-4:i386 libvorbisfile3:i386 libsfml-dev:i386 libcrypto++-dev:i386 curl:i386 libcurl4-openssl-dev:i386 \
    libfreetype6:i386 libxrandr2:i386 libgtk2.0-0:i386 libpango-1.0-0:i386 libnss3-dev:i386 libpangocairo-1.0-0:i386 \
    libasound2-dev:i386 libgdk-pixbuf2.0-0:i386"
# List of package used for RedHat :
yum="GConf2.i686 libvorbis.i686 SFML.i686 SFML-devel.i686 cryptopp.i686 libcurl.i686 libcurl-devel.i686 \
    freetype.i686 freetype-devel.i686 libXrandr.i686 libXrandr-devel.i686 gtk2.i686 gtk2-devel.i686 \
    pango.i686 pango-devel.i686 cairo.i686 cairo-devel.i686 gtk-pixbuf2-devel.i686 gtk-pixbuf2.i686"
# List of package used for Arch :
pacman="gconf lib32-libvorbis sfml crypto++ lib32-libgcrypt curl lib32-nss lib32-openssl lib32-libfreetype \
    lib32-libxrandr lib32-gtk2 lib32-pango libtiger lib32-gdk-pixbuf2"

# Bash trap function:
bashtrap () {
    echo -e "${red}CTRL+C Detected !... If you want exit please use \"Q\" or \"q\".${nc}"
}

# Function used to ask if the user want to launch the game :
function LaunchGame () {
    local step=true
    while ${step}; do
        echo -e "${yellow}Do you want launch Dungeon Defender?(Y/N)${nc}"
        read answer
        case ${answer} in
            Y|y)
                steam steam://rungameid/302270 &
                step=false
                ;;
            N|n)
                echo -e "${yellow}Quiting...${nc}"
                step=false
                ;;
            *)
                echo -e "${yellow}Please use Y or N.${nc}"
                step=true
                ;;
        esac
    done
}

function CheckLibs () {
    ## Check for available libs :
    echo -e "${purple}------------------------------------------------------${nc}"
    echo -e "${yellow}Installed Libs :${nc}"
    echo `ldd ${DUNDEF_LAUNCHER_PATH} | grep lib  | tr "\t" " " | cut -d"=" -f1`
    echo -e "${purple}------------------------------------------------------${nc}"

    ## Check for unavailable libs :
    echo -e "${yellow}Missing Libs :${nc}"
    echo `ldd ${DUNDEF_LAUNCHER_PATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo -e "${purple}------------------------------------------------------${nc}"

    echo ""
    echo -e "${yellow}Directories used for your libs${nc}"
    # Prints out all directory used to provide your libs
    sudo ldconfig -v 2>/dev/null | grep -v ^$'\t'
    echo -e "${purple}------------------------------------------------------${nc}"
}

function Check64bit () {
    if [ $(getconf LONG_BIT) -eq "64" ]; then
        echo -e "${red}You use a 64 bit Linux${nc}"
        # If debian/Ubuntu
        if [ ${1} = "dpkg" ];then
            echo -e "${yellow}Add i386 arch${nc}"
            sudo dpkg --add-architecture i386
        fi

        # If Arch
        if [ ${1} = "pacman" ];then
            line=$(grep -n -A 2 "#\[multilib\]" pacman.conf | grep -o '[0-9]\{2,3\}')
            if [[ -n "${line}" ]]; then
                echo -e "${yellow}Enabling 'MultiLib' Repo :${nc}"
                for num in ${line}; do
                    sed -i ''${num}'s/#//' pacman.conf
                done
            fi
        fi
        ## If Redhat nothing to do.
    else
        echo -e "{red}You use a 32 bit Linux.${nc}"
        echo -e "{red}Change package list to 32 bit package.${nc}"
        # Change to 32 bit package (Debian):
        apt="libgconf-2-4 libvorbisfile3 libsfml-dev libcrypto++-dev curl libcurl4-openssl-dev libfreetype6 libxrandr2 \
            libgtk2.0-0 libpango-1.0-0 libnss3-dev libpangocairo-1.0-0 libasound2-dev libgdk-pixbuf2.0-0"
        # Change to 32 bit package (RedHat):
        yum="GConf2 libvorbis SFML SFML-devel cryptopp libcurl libcurl-devel freetype freetype-devel libXrandr \
            libXrandr-devel gtk2 gtk2-devel pango pango-devel cairo cairo-devel gtk-pixbuf2-devel gtk-pixbuf2"
        # Change to 32 bit package (Arch):
        pacman="gconf libvorbis sfml crypto++ libgcrypt curl nss openssl libfreetype libxrandr gtk2 pango libtiger \
                gdk-pixbuf2"
    fi
}

function SymLinkFix () {
    CheckLibs

    ## Doing job
    ln -sf ${STEAM_LIB_PATH}/usr/lib/i386-linux-gnu/* ${DUNDEF_LIB_PATH}
    ln -sf ${STEAM_LIB_PATH}/lib/i386-linux-gnu/* ${DUNDEF_LIB_PATH}

    clear
    echo -e "${yellow}Symlinking Done!${nc}"
    echo -e "${purple}------------------------------------------------------${nc}"
    echo -e "${yellow}Missing libs :${nc}"
    echo `ldd ${DUNDEF_LAUNCHER_PATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo -e "${purple}------------------------------------------------------${nc}"
}

function PandaFix () {
    CheckLibs

    # Installing Main libs
    ## Debian Flavours
    if [[ -x "$(which apt-get)" ]]; then
        Check64bit dpkg
        echo -e "${yellow}Installing missing libs :${nc}"
        sudo apt-get update && sudo apt-get install ${apt}

    elif [[ -x "$(which aptitude)" ]]; then
        Check64bit dpkg
        echo -e "${yellow}Installing missing libs :${nc}"
        sudo aptitude update && sudo aptitude install ${apt}
    fi

    ## Red Hat Flavours
    if [[ -x "$(which yum)" ]]; then
        Check64bit yum
        echo -e "${yellow}Installing missing libs :${nc}"
        sudo yum update && sudo yum install ${yum}
    fi

    ## ArchLinux Flavours
    if [[ -x "$(which pacman)" ]]; then
        Check64bit pacman
        echo -e "${yellow}Installing missing libs :${nc}"
        echo -e "${yellow}/!\ Support of pacman package manager is currently in testing...${nc}"
        sudo pacman -Syy && sudo pacman -S ${pacman}
    fi

    echo -e "${purple}------------------------------------------------------${nc}"
    echo -e "${yellow}Missing Libs :${nc}"
    echo `ldd ${DUNDEF_LAUNCHER_PATH} | grep "not found" | tr "\t" " " | cut -d"=" -f1`
    echo -e "${purple}------------------------------------------------------${nc}"
}

Cleaning () {
    echo -e "${yellow}Cleaning symlink fix...${nc}"
    find "$DUNDEF_LIB_PATH" -maxdepth 1 -type l -exec rm -f {} \;
    echo -e "${yellow}Cleaning done...${nc}"
}

#Show menu :
while true; do
    echo -e "${purple}+----------------------------+${nc}"
    echo -e "${purple}|${nc} ${yellow}[ Choose your workaround ]${nc} ${purple}|${nc}"
    echo -e "${purple}+----------------------------+------------------------${nc}"
    echo -e "${purple}|${nc} ${yellow}[1] -> SymLink Fix   --> Create all symlinks needed to fix your issue. (All Linux OS)${nc}"
    echo -e "${purple}|${nc} ${yellow}[2] -> PandaWan Fix  --> Install all package needed for your game. (All Linux OS)${nc}"
    echo -e "${purple}|${nc} ${yellow}[3] -> ShowMyLibs    --> Show all directories used to provide your Libs (All Linux OS)${nc}"
    echo -e "${purple}|${nc} ${yellow}[4] -> Cleaning      --> Remove Symlink Fix!${nc}"
    echo -e "${purple}|${nc} ${yellow}[Q] -> Quit          --> Exit...${nc}"
    echo -e "${purple}+-----------------------------------------------------${nc}"
    echo -e "${yellow}Your choice : ${nc}"
    read choice

    case ${choice} in
        1)
            SymLinkFix
            LaunchGame
            ;;
        2)
            PandaFix
            LaunchGame
            ;;
        3)
            # Prints out all directories used to provide your libs
            CheckLibs
            ;;
        4)
            Cleaning
            ;;
        Q|q)
            exit 0;
            ;;
        *)
            echo -e "${red}${choice} is not available${nc}"
            ;;
    esac
done
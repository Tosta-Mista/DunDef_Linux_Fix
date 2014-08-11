DunDef3.2_Linux_Fix
===================
Quick fix for Dungeon Defender Eternity Linux 3.2 build. I can only test this patch on Debian Flavours... 
Archlinux, Gentoo and other linux flavours testers are welcome! => Open an issue with your result.

Thanks in advance.
## Add a new fix 
Create your function :
```shell
function NameOfFix {
    # Put your fix here!
}
```

Add an entry into the loop :
```shell
while true; do
    echo "What workaround do you want?"
    echo "----------------------------"
    echo " 1 - Edge Fix --> Symlink way (Work on Redhat/Fedora and Debian/Ubuntu)"
    echo " 2 - PandaWan Fix --> Package way (Work on Debian/Ubuntu 64 bit) "
    echo " 3 - Adrian Fix --> Symlink way (Work on ArchLinux)"
---> new entry here (echo " Number - NameOfYourFix --> Description")
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
---> new entry here ( Number) FunctionName - Cleaningfunction - exit 0; ;;)
        Q|q)
            cleaning
            exit 0;
            ;;
        *)
            echo "Please choose something available on the list..."
            ;;
    esac
done
```

## How to use
### Download the script :
#### With Git :<br />
```
git clone https://github.com/Tosta-Mixta/DunDef3.2_Linux_Fix.git
```
#### Without Git : <br />
https://github.com/Tosta-Mixta/DunDef3.2_Linux_Fix/archive/master.zip<br />
#### Wget :<br />
```
wget https://github.com/Tosta-Mixta/DunDef3.2_Linux_Fix/archive/master.zip
```

### Set your path
Set PATH constant with your Dungeon defender path.
```shell
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
```

### Run
Add permission to the script :
```shell
chmod +x DungeonDefenderLinux_Fix.sh
```

Launch :
```shell
./DungeonDefenderLinux_Fix.sh
```

## Misc :
I hope this scripts can help somebody.

Thank you very much @bubylou for your contribution.
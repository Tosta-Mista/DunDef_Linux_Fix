DunDef3.2_Linux_Fix
===================
Quick fix for Dungeon Defender Eternity Linux 3.2 build

## Add a new fix 
Create your function :
```
function NameOfFix {
    # Put your fix here!
}
```

Add an entry into the loop :
```
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
set DUNDEFPATH variable with your Dungeon defender path

'''Add permission to the script'''
```
sudo chmod +x DungeonDefenderLinux_Fix.sh
```

'''Launch'''
```
./DungeonDefenderLinux_Fix.sh
```

''' Misc'''
I hope this scripts can help somebody.

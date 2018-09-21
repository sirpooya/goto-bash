#!/bin/bash
# Copyright (c) 2018 Pooya Kamel <pooyakamel@gmail.com>
# by Pooya Kamel
#
# name           Goto command function
# version        1.0.0
# description    Goto cmd for OSX Terminal
# homepageURL    https://github.com/sirpooya/goto-bash
# supportURL     https://github.com/sirpooya/goto-bash/issues
# author         Pooya Kamel
# license        GPL

uplink() {
    #T0DO : uplink <source name> <destination name> -- makes hard link
    #/usr/local/bin/goto
    link_file=.link
    if [[ ! -f $link_file ]]; then
    echo "No Link file found"
    else 
        item=`grep ":" ".link"`;
        if [[ -z $item ]]; then
            echo 'No items found to Link'
        else
            file=`echo "$item" | cut -d\: -f1`
            link=`echo "$item" | cut -d\: -f2`
            ln -vif "$file" "$link"
            chmod +x "$link"
            #. ~/.bash_profile
            #export PATH=$PATH":$HOME/bin"
        fi
    fi
}

opent() { if [ $# -eq 0 ] ; then echo "no input!"; url=`pwd`; parent="${PWD##*/}";
else url=($1); parent="${$1##*/}"; fi;
osascript  -e 'tell application "Finder"' -e 'activate' -e 'tell application "System Events"' -e 'keystroke "t" using command down' -e 'end tell' -e 'set target of front Finder window to ("'$url'" as POSIX file)' -e 'end tell' -e 'say "'$parent'"' ; echo $parent; }

goto() {
    while [ $# -gt 0 ]; do
        arg=$1;
        case $arg in
            "--version" )
                showVersion;
                break ;;

            "info" )
                info=`osascript -e 'tell application "Finder"
                end tell
                return 0'`
                cecho "$info";
                break ;;

            "share"     )
                adr=$PWD
                echo -n $adr | pbcopy
                break;;

            "help" | * )
                showHelp;
                break ;;

            "-a" | * )
                showHelp;
                break ;;
        esac
    done

    else url="$1"; 
    fi ;
 
}


showVersion () {
    echo "goto v1.0.0";
}

showHelp () {
    echo "Usage:";
    echo;
    echo "  `basename $0` <command>";
    echo;
    echo "Commands:";
    echo;
    echo "  go <bookmark name>               # Gos to directory.";
    echo "  save <bookmark name>             # make new alias to directory.";
}

#if [ $# = 0 ]; then
    #showHelp;
#fi


# T0DO : add shorcuts to this function
# $ goto -a apps /Applications
# $ goto -a
# apps     docs    sites
# $ goto apps
# $ goto photos
# Shortcut not found

# T0D0 : version-ing be like:
# $ goto --version
# Goto v1.0.0
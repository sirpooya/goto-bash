#!/bin/bash
# Copyright (c) 2018 Pooya Kamel <sirpooya@outlook.com>
# by Pooya Kamel
# 

# name           Goto command function
# version        1.0.0
# description    Goto cmd for OSX Terminal opens address
#                in new Finder Tab
# homepageURL    https://github.com/sirpooya/goto
# supportURL     https://github.com/sirpooya/goto-bash/issues
# author         Pooya Kamel
# license        GPL

update() {
    sync_file=./.sync
    if [[ ! -f $sync_file ]]; then
    echo "Sync file not found"
    fi

    sync=`grep "|" "./.sync"`

    if [[ -z $sync ]]; then
        echo 'Sync File is empty or corrupted'
    else
        dir=`echo "$sync" | cut -d\| -f1`
        cp -biu "$dir"
    fi
    #export PATH=$PATH":$HOME/bin"
    #chmod +x filename
    #. ~/.bash_profile
}

go() { url=`pwd` ; parent="${PWD##*/}"; osascript  -e 'tell application "Finder"' -e 'activate' -e 'tell application "System Events"' -e 'keystroke "t" using command down' -e 'end tell' -e 'set target of front Finder window to ("'$url'" as POSIX file)' -e 'end tell' -e 'say "'$parent'"' ; echo $parent; }

goto() {
    if [ $# -eq 0 ] ; then
    url=`pwd`;
    elif [ $# = "ver" ] ; then 
    echo "Goto 1.0"; 
    else url="$1"; 
    fi ; 
    osascript  -e 'tell application "Finder"' -e 'activate' -e 'tell application "System Events"' -e 'keystroke "t" using command down' -e 'end tell' -e 'set target of front Finder window to ("'$url'" as POSIX file)' -e 'end tell' -e 'say ""' ;
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

if [ $# = 0 ]; then
    showHelp;
else
    if [ $(osascript -e 'application "Spotify" is running') = "false" ]; then
        osascript -e 'tell application "Spotify" to activate'
        sleep 2
    fi
fi

while [ $# -gt 0 ]; do
    arg=$1;

    case $arg in
        "play"    )
            if [ $# != 1 ]; then
                # There are additional arguments, so find out how many
                array=( $@ );
                len=${#array[@]};

                searchAndPlay() {
                    type="$1"
                    Q="$2"
                }

                case $2 in
                    "list"  )
                        _args=${array[@]:2:$len};
                        Q=$_args;

                        cecho "Searching playlists for: $Q";

                        results=$( \
                            curl -s -G $SPOTIFY_SEARCH_API --data-urlencode "q=$Q" -d "type=playlist&limit=10&offset=0" -H "Accept: application/json" -H "Authorization: Bearer ${SPOTIFY_ACCESS_TOKEN}" \
                            | grep -E -o "spotify:user:[a-zA-Z0-9_]+:playlist:[a-zA-Z0-9]+" -m 10 \
                        )

                        count=$( \
                            echo "$results" | grep -c "spotify:user" \
                        )

                    "album" | "artist" | "track"    )
                        _args=${array[@]:2:$len};
                        searchAndPlay $2 "$_args";;

                    "uri"  )
                        SPOTIFY_PLAY_URI=${array[@]:2:$len};;

                    *   )
                        _args=${array[@]:1:$len};
                        searchAndPlay track "$_args";;
                esac

                if [ "$SPOTIFY_PLAY_URI" != "" ]; then
                    cecho "Playing Spotify URI";
                else
                    cecho "No results when searching";
                fi

            else

                # play is the only param
                cecho "Playing Spotify.";
                osascript -e 'tell application "Spotify" to play';
            fi
            break ;;

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
            uri=$PWD
            echo -n $uri | pbcopy
            break;;

        "help" | * )
            showHelp;
            break ;;
    esac
done
# add shorcuts to this function
# $ goto -a apps /Applications
# $ goto -a
# apps     docs    sites
# $ goto apps
# $ goto photos
# Shortcut not found

# version-ing be like:
# $ goto --version
# Goto v1.0.0
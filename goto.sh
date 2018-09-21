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
        item=`grep "→" ".link"`;
        if [[ -z $item ]]; then
            echo 'No items found to Link'
        else
            file=`echo "$item" | cut -d\→ -f1`
            link=`echo "$item" | cut -d\→ -f2`
            ln -vif "$file" "$link"
            chmod +x "$link"
            #. ~/.bash_profile
            #export PATH=$PATH":$HOME/bin"
        fi
    fi
}

cecho(){
    bold=$(tput bold);
    green=$(tput setaf 3);
    reset=$(tput sgr0);
    echo $bold$green"$1"$reset;
}

opent() { 
    # T0DO : open directories inside : opent bin --> opne ./bin    
    if [ $# -eq 0 ] ; then url=`pwd`; parent="${PWD##*/}";
    else url=($1); parent="${url##*/}"; fi;
    osascript  -e 'tell application "Finder"' -e 'activate' -e 'tell application "System Events"' -e 'keystroke "t" using command down' -e 'end tell' -e 'set target of front Finder window to ("'$url'" as POSIX file)' -e 'end tell' -e 'say "'$parent'"' ; cecho "🙂 Opening \"$parent\" ...";
}



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

            "share/-cp"     )
                adr=$PWD
                echo -n $adr | pbcopy
                break;;

            "help" | * )
                showHelp;
                break ;;

            "-b" )
                showHelp;
                break ;;
        esac
    done
 
}


showVersion () {
    echo "goto v1.0.0";
}

showHelp () {
    echo "  USAGE:";
    echo;
    echo "    Goto <command>";
    #echo "  `basename $0` <command>";
    echo;
    echo "  COMMANDS:";
    echo;
    echo "    opent                             # Open current directory in new Finder Tab.";
    echo "    opent <location>                  # Open location in new Finder Tab.";
    echo;
    echo "    go                                # Shows help.";
    echo "    go <directory>                    # Goes to directory.";
    echo "    go -all                           # Shows all bookmarks.";
    echo "    go <bookmark name>                # Goes to bookmarked directory.";
    echo "    go -b                             # Saves current directory to bookmarks with original folder name .";
    echo "    go -b <bookmark name>             # Saves current directory to bookmarks with given name";   
    echo;
    echo "    mkals                             # Makes Finder Alias";
    echo "    search                            # Searchs for a keyword in files & folders";
    echo "    own                               # Change file ownership as root & executable.";
    echo;
    echo "    help                              # show help file.";
    echo "    --version                         # Show version.";
    echo;
    echo;
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



"-b"    )
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
        # Show Bookmarks
        cecho "Playing Spotify.";
        osascript -e 'tell application "Spotify" to play';
    fi
    break ;;
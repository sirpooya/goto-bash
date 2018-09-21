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





bookmarks_file=~/.bookmarks

# Create bookmarks_file it if it doesn't exist
if [[ ! -f $bookmarks_file ]]; then
  touch $bookmarks_file
fi

bookmark (){
  bookmark_name=$1

  if [[ -z $bookmark_name ]]; then
    echo 'Invalid name, please provide a name for your bookmark. For example:'
    echo '  bookmark foo'
  else
    bookmark="`pwd`|$bookmark_name" # Store the bookmark as folder|name

    if [[ -z `grep "|$bookmark_name" $bookmarks_file` ]]; then
      echo $bookmark >> $bookmarks_file
      echo "Bookmark '$bookmark_name' saved"
    else
      echo "Bookmark '$bookmark_name' already exists. Replace it? (y or n)"
      while read replace
      do
        if [[ $replace = "y" ]]; then
          # Delete existing bookmark
          sed "/.*|$bookmark_name/d" $bookmarks_file > ~/.tmp && mv ~/.tmp $bookmarks_file
          # Save new bookmark
          echo $bookmark >> $bookmarks_file
          echo "Bookmark '$bookmark_name' saved"
          break
        elif [[ $replace = "n" ]]; then
          break
        else
          echo "Please type 'y' or 'n'"
        fi
      done
    fi
  fi
}

# Delete the named bookmark from the list
bookmarkdelete (){
  bookmark_name=$1

  if [[ -z $bookmark_name ]]; then
    echo 'Invalid name, please provide the name of the bookmark to delete.'
  else
    bookmark=`grep "|$bookmark_name$" "$bookmarks_file"`

    if [[ -z $bookmark ]]; then
      echo 'Invalid name, please provide a valid bookmark name.'
    else
      cat $bookmarks_file | grep -v "|$bookmark_name$" $bookmarks_file > bookmarks_temp && mv bookmarks_temp $bookmarks_file
      echo "Bookmark '$bookmark_name' deleted"
    fi
  fi
}

# Show a list of the bookmarks
bookmarksshow (){
  cat $bookmarks_file | awk '{ printf "%-40s%-40s%s\n",$1,$2,$3}' FS=\|
}
go(){
  bookmark_name=$1

  bookmark=`grep "|$bookmark_name$" "$bookmarks_file"`

  if [[ -z $bookmark ]]; then
    echo 'Invalid name, please provide a valid bookmark name. For example:'
    echo '  go foo'
    echo
    echo 'To bookmark a folder, go to the folder then do this (naming the bookmark 'foo'):'
    echo '  bookmark foo'
  else
    dir=`echo "$bookmark" | cut -d\| -f1`
    cd "$dir"
  fi
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

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

cecho() {
    arg=$1;
    arg2=$2;
    if [[ -z $arg2 ]] ; then
      color=$(tput setaf 4);
    else
      while [ $2 -gt 0 ] ; do
        case $arg2 in
          "1" ) #red
            color=$(tput setaf 1);
            break ;;

          "2" ) #green
            color=$(tput setaf 2);
            break ;;

          "3" ) #yellow
            color=$(tput setaf 3);
            break ;;

          "4" ) #blue
            color=$(tput setaf 4);
            break ;;

          "5" ) #magenta
            color=$(tput setaf 5);
            break ;;

          "6" ) #cyan
            color=$(tput setaf 6);
            break ;;
        esac
      done
    fi
    bold=$(tput bold);
    reset=$(tput sgr0);
    echo $bold$color$arg$reset;
}

opent() { 
    # T0DO : open directories inside : opent bin --> opne ./bin    
    if [ $# -eq 0 ] ; then url=`pwd`; parent="${PWD##*/}";
    else url=($1); parent="${url##*/}"; fi;
    osascript  -e 'tell application "Finder"' -e 'activate' -e 'tell application "System Events"' -e 'keystroke "t" using command down' -e 'end tell' -e 'set target of front Finder window to ("'$url'" as POSIX file)' -e 'end tell' -e '--say "'$parent'"' ; cecho "🙂 Opening \"$parent\" ..." 5;
}





bookmarks_file=~/.bookmarks

# Create bookmarks_file it if it doesn't exist
if [[ ! -f $bookmarks_file ]]; then
  touch $bookmarks_file
fi

bookmark (){
  bookmark_name=$1

  if [[ -z $bookmark_name ]]; then
    cecho '💩 Please type a valid name for your bookmark.' 3;
  else
    bookmark="`pwd`|$bookmark_name" # Store the bookmark as folder|name

    if [[ -z `grep "|$bookmark_name" $bookmarks_file` ]]; then
      echo $bookmark >> $bookmarks_file
      cecho "✅ Bookmark '$bookmark_name' saved" 2;
 
    else
      cecho "🐵 Bookmark '$bookmark_name' already exists. Replace it? (y or n)" 5;
      while read replace
      do
        if [[ $replace = "y" ]]; then
          # Delete existing bookmark
          sed "/.*|$bookmark_name/d" $bookmarks_file > ~/.tmp && mv ~/.tmp $bookmarks_file
          # Save new bookmark
          echo $bookmark >> $bookmarks_file
          cecho "✅ Bookmark '$bookmark_name' saved" 2;
          break
        elif [[ $replace = "n" ]]; then
          break
        else
          cecho "Please type 'y' or 'n' :" 5;
        fi
      done
    fi
  fi
}

# Delete the named bookmark from the list
deletemark (){
  bookmark_name=$1

  if [[ -z $bookmark_name ]]; then
    cecho '👊 Name Can not be empty.' 3;
  else
    bookmark=`grep "|$bookmark_name$" "$bookmarks_file"`

    if [[ -z $bookmark ]]; then
      cecho '🙈 Invalid name, please provide a valid bookmark name.' 3;
    else
      cat $bookmarks_file | grep -v "|$bookmark_name$" $bookmarks_file > bookmarks_temp && mv bookmarks_temp $bookmarks_file
      cecho "❌ Bookmark '$bookmark_name' deleted" 1;
    fi
  fi
}

# Show a list of the bookmarks
showmarks (){
  yellow=$(tput setaf 3); normal=$(tput sgr0);
  cat $bookmarks_file | awk '{ printf "👉 '${yellow}'%-10s'${normal}'%s\n",$2,$1}' FS=\|
  #cat $bookmarks_file | awk '{ printf "%-40s%-40s%s\n",$1,$2,$3}' FS=\|
}

goto(){
  bookmark_name=$1

  bookmark=`grep "|$bookmark_name$" "$bookmarks_file"`

  if [[ -z $bookmark ]]; then
    cecho '🙈 Invalid name, please provide a valid bookmark name. For example:'
    echo '  go foo'
    echo
    echo 'To bookmark a folder, go to the folder then do this (naming the bookmark 'foo'):'
    echo '  bookmark foo'
  else
    dir=`echo "$bookmark" | cut -d\| -f1`
    cd "$dir"
  fi
}

goback() {
  cd $OLDPWD;
}

cpydir() {
  adr=$PWD;
  echo -n $adr | pbcopy;
  }

go() {
    if [ $# -eq 0 ] ; then
      showmarks;
    fi
    while [ $# -gt 0 ]; do
        arg=$1;
        case $arg in
            "-ver"  | "--version")
              showVersion;
              break ;;

            "-cp"    )
              cpydir;
              break;;

            "-s" | "-b"   )
              bookmark $2;
              break ;;

            "-d" )
              deletemark $2;
              break ;;

            "help" )
              showHelp;
              break ;;
            * )
                if [ $# != 1 ]; then
                  cecho "🙈 Whaaaat?!!";
                else
                  goto $1;
                fi
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
    echo "    go /User/ ./Home ~/help           # Goes to directory.";
    echo "    go -all | -list                   # Shows all bookmarks.";
    echo "    go <bookmark name>                # Goes to bookmarked directory.";
    echo "    go -s <bookmark name> | --save    # Saves current directory to bookmarks with given name";
    echo "    go back                           # Goes back in history";
    echo "    go -cp                            # Copy address to clipboard";
    echo "    go -d                             # Deletes bookmark";
    echo;
    echo "    mkals                             # Makes Finder Alias";
    echo "    search                            # Searchs for a keyword in files & folders";
    echo "    own                               # Change file ownership as root & executable.";
    echo;
    echo "    help                              # show help file.";
    echo "    -ver                         # Show version.";
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

#!/bin/bash
# Copyright (c) 2018 Pooya Kamel <sirpooya@outlook.com>
# by Pooya Kamel
# 

# name           Goto command function
# version        1.0.0
# description    Goto cmd for OSX Terminal opens address
#                in new Finder Tab
# homepageURL    https://github.com/sirpooya/goto
# supportURL     https://github.com/sirpooya/Trello-Stylish/issues
# author         Pooya Kamel
# license        GPL

go() { url=`pwd` ; parent="${PWD##*/}"; osascript  -e 'tell application "Finder"' -e 'activate' -e 'tell application "System Events"' -e 'keystroke "t" using command down' -e 'end tell' -e 'set target of front Finder window to ("'$url'" as POSIX file)' -e 'end tell' -e 'say "'$parent'"' ; echo $parent; }

goto() { if [ $# -eq 0 ] ; then url=`pwd`; elif [ $# = "ver" ] ;then echo "Goto 1.0"; else url="$1"; fi ; osascript  -e 'tell application "Finder"' -e 'activate' -e 'tell application "System Events"' -e 'keystroke "t" using command down' -e 'end tell' -e 'set target of front Finder window to ("'$url'" as POSIX file)' -e 'end tell' -e 'say ""' ; }

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
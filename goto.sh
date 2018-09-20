#!/bin/bash
# function Goto for OSX Terminal opens address in new Finder Tab

goto() { if [ $# -eq 0 ] ; then url=`pwd`; elif [ $# = "ver" ] ;then echo "Goto 1.0"; else url="$1"; fi ; osascript  -e 'tell application "Finder"' -e 'activate' -e 'tell application "System Events"' -e 'keystroke "t" using command down' -e 'end tell' -e 'set target of front Finder window to ("'$url'" as POSIX file)' -e 'end tell' -e 'say ""' ; }

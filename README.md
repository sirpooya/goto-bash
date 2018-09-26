# go() command for bash
`goto-bash`
`goto-terminal`
`goto-command`
`goto-function`

![Screenshot](goto_bash.png)

🍺 Provides bookmarking ability for folders/directories in bash.

🍺 Open any directory inside of Finder _tab_ instead of window (macOS).

🍺 Go to any directory or folder alias you created.



/Users/sirrichard/Library/Services

2. 	copy it to your home folder

		sudo cp goto-bash/goto.sh ~/bin

3. source it in `.bashrc` or `.bash_profile` (or other bash startup file):

		source ~/bin/bashmarks.sh
		
# Usage		

###1. Bookmarking

Go to folder, then bookmark it like so:

	go -s <bookmark name>

###2. Go to bookmark folder

When you want to go to a bookmark:

	go <bookmark name>

###3. Bookmark list
To view list of all bookmarks :
 
	go
or

	go -list

###4. Auto Completion
For using auto-completion feature, simply press [tab]:

	go app[tab]







#Installation
-
### Method 1 - Brew

	brew install goto

### Method 2 - clone
	git clone https://github.com/sirpooya/goto-bash.git goto-bash
	sudo cp goto-bash/src/goto.sh /etc/

### Method 3 - wget
	sudo wget -O /etc/goto.sh https://raw.githubusercontent.com/sirpooya/goto-bash/master/src/goto.sh


#Configuration
Then source this file before you source the script:

	if [ -f /etc/bash.command-not-found-messages ]; then
	    . /etc/bash.command-not-found-messages
	fi
	
	if [ -f /etc/bash.command-not-found ]; then
	    . /etc/bash.command-not-found
	fi


--
# opent
`open-in-tab`

***opent*** is a simple Bash/Apple script to empower `open` command in Terminal & open current directory in Finder _Tab_ from command line on a Mac.

If you find this interesting, you should [follow me on
Twitter](https://twitter.com/copingbear) to learn about the other
things I do.

## Installation

### Homebrew

The easiest way to install shpotify is by using the [Homebrew package
manager](http://brew.sh):

`
brew install opent
`

### Manual installation

If you don’t use Homebrew, you can install the script manually by
following a few simple steps:

1. Fetch a copy of this repository, either with git or [download the
   zip archive](https://github.com/hnarayanan/shpotify/archive/master.zip).

2. Navigate to the folder where you fetched the repository (unzip if
   needed) and make sure the file called `spotify` is executable:
   ````
   cd shpotify
   chmod +x spotify
   ````

3. Copy the file `spotify` to a convenient location in your `PATH`, or
   set your `PATH` to include the folder where the file is located.


## Usage

With shpotify you can control Spotify with the following commands:
		
	spotify next                       Skips to the next song in a playlist.
	spotify prev                       Returns to the previous song in a playlist.
	spotify replay                     Replays the current track from the beginning.
	spotify pos <time>                 Jump to a specific time (in seconds) in the current song.
	spotify pause                      Pauses (or resumes) Spotify playback.
	spotify stop                       Stops playback.
	spotify quit                       Stops playback and quits Spotify.


---
Hello there! I’m **MacDown**, the open source Markdown editor for OS X.

Let me introduce myself.


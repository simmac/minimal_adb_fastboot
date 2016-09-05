#!/bin/bash
clear
echo -e "\n\nQuick adb/fastboot installer 3.3.0\n"

#Gets location of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#		FUNCTIONS SECTION BEGIN			#
#---------------------------------------#

function oscheck () {
	# Checks if linux or OS X and sets parameters
	# function is called "oscheck"
	if [ "$(uname -s)" == "Darwin" ]; then #OS X
		INSTALLPATH="/usr/local/bin"
		INSTALLPATH_OLD="/usr/bin"
		BINPATH="$DIR/osx"
		MD5="md5 -q"
	else	#we assume it's (debian) linux
		INSTALLPATH="/usr/local/bin"
		BINPATH="$DIR/linux"
		MD5="md5sum"
	fi
	
	#check whether the installation directory exists and creates it if needed.
	if [ ! -d "$INSTALLPATH" ]; then
		echo -e "The target directory doesn't exist. This script will create the directory for you."
		echo -e "You may be asked for your password now. \n"
		sudo mkdir $INSTALLPATH
		echo -e "\nDirectory created. The installation script will begin now.\n"
	fi
}


function versioncheck () {
	# CHECKS IF BINARY VERSIONS MATCH
	# 0 = match, 1 = no match, 2 = no installation 
	# function is called "versioncheck $1"
	# while $1 is either adb or fastboot
	
	if [ -f $INSTALLPATH/$1 ]; then
	
		echo -e "Comparing checksums...\n"
		#check md5 match
		MD5BIN="$($MD5 $BINPATH/$1)"
		MD5INSTALLED="$($MD5 $INSTALLPATH/$1)"
		if [ "$MD5BIN" == "$MD5INSTALLED" ]; then
			return 0;
		else
			return 1;
		fi
	
	else
		return 2;
	fi	
}

function install () {
	# INSTALLATION ROUTINE
	# function is called "install $1"
	# while $1 is either adb or fastboot
	
	sudo cp $BINPATH/$1 $INSTALLPATH/$1
	
	versioncheck $1
	if [ "$?" == "0" ]; then
		return 0;
	else
		return 1;
	fi
}

function fullinstall () {
	# This does the full installation process
	# including the versionchecks
	
	# function is called "install $1"
	# while $1 is either adb or fastboot
	versioncheck $1
		if [ "$?" == "0" ]; then
			echo -e "$1 binaries are up to date. No need for installation.\n"
			return 0;
		else
			install $1;
			
			if [ "$?" == "0" ]; then
				echo -e "Installation of $1 completed successfully!\n"
			return 0;
			
			else
				echo -e "Sorry, something went wrong :(\n"
				echo -e "$1 is not installed.\n"
				return 1;
			fi
		fi
}

function uninstall () {
	# UNINSTALLATION ROUTINE
	# function is called "uninstall $1"
	# while $1 CAN be "old", standard is empty
	
	if [ "$1" == "old" ]; then
		INSTALLPATH="$INSTALLPATH_OLD"
	fi
	
	sudo rm -f $INSTALLPATH/adb
	sudo rm -f $INSTALLPATH/fastboot
	sudo rm -f $INSTALLPATH/aapt

	if [ -f "$INSTALLPATH/adb" ] || [ -f "$INSTALLPATH/fastboot" ]; then
		return 1;
	else
		return 0;
	fi
}


#		FUNCTIONS SECTION END			#
#---------------------------------------#

oscheck

case $1 in								#reads first argument
	
	"")
		echo -e "super user rights are needed."
		echo -e "You may be prompted for your admin password now.\n"
		fullinstall adb
		A="$?"							#stores return of "fullinstall adb" in $A
		
		fullinstall fastboot
		
		if [ "$A" == 0 ] && [ "$?" == 0 ]; then
			echo -e "\n\n\n\nComplete installation completed successfully!\n"
			echo -e "Thanks for using Quick adb/fastboot!\n Quitting now...\n"
			exit 0;
		else
			echo -e "\n\n\n\nSorry, installation was unsuccessful!\n"
			"Thanks for using Quick adb/fastboot!\n Quitting now...\n"
			exit 1;
		fi
		;;
	
	
	uninstall)
		echo -e "super user rights are needed."
		echo -e "You may be prompted for your admin password now.\n"
		uninstall
	
		if [ "$?" == "0" ]; then
			echo -e "Uninstall successful!\n Quitting now..."
			echo -e "Thanks for using Quick adb/fastboot!"
			exit 0;
		else
			echo -e "Sorry, something went wrong :(\n"
			echo -e "adb or fastboot are still installed.\n Quitting now..."
			exit 1;
		fi
		;;
	
	adb|fastboot)
		echo -e "super user rights are needed."
		echo -e "You may be prompted for your admin password now.\n"
		fullinstall $1
		
		echo -e "Thanks for using Quick adb/fastboot!\n Quitting now...\n"
		exit $?;
		
		;;
		
	uninstall-old)
		echo -e "super user rights are needed."
		echo -e "You may be prompted for your admin password now.\n"
		uninstall old
	
		if [ "$?" == "0" ]; then
			echo -e "Uninstall successful!\n Quitting now..."
			echo -e "Thanks for using Quick adb/fastboot!"
			exit 0;
		else
			echo -e "Sorry, something went wrong :(\n"
			echo -e "adb or fastboot are still installed in /usr/bin.\n Quitting now..."
			exit 1;
		fi
		;;
		
	*)
		echo -e "Invalid argument "$1"! \n Quitting now...\n"
		exit 1;
		
		;;
		
esac

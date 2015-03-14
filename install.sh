#!/bin/bash
clear
echo -e "\n\nQuick adb/fastboot installer 2.0 .\n"

#Gets location of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Check if linux or OS X and setting parameters
if [ "$(uname -s)" == "Darwin" ]; then #OS X
	INSTALLPATH="/usr/bin"
	BINPATH="$DIR/osx"
	MD5="md5 -q"
else	#we assume it's (debian) linux
	INSTALLPATH="/usr/local/bin"
	BINPATH="$DIR/linux"
	MD5="md5sum"
fi

#This checks the adb version of the provided bins and the installed adb.
VERSION="$($BINPATH/./adb version | cut -d ' '  -f5)"
{ VERSIONINSTALLED="$(adb version | cut -d ' '  -f5)"; } &> /dev/null

#This is checking if the installed adb version is up to date.
if [ "$VERSION" == "$VERSIONINSTALLED" ]; then
		
		echo -e "Comparing checksums...\n"
		#check md5 match
		MD5BIN="$($MD5 $BINPATH/adb)"
		MD5INSTALLED="$($MD5 $(which adb))"
		if [ "$MD5BIN" != "$MD5INSTALLED" ]; then
			echo -e "Although the version number of the adb binary didn't change, the file itself changed. "
			echo -e "Probably there was a minor patch in the binary. Do you want to update the adb binary?\n"
			read -p "Please enter y(es) or n(o): " yn
			case $yn in
				[Yy]* ) ;;
				[Nn]* ) echo -e "Quitting...\n\n"; exit 0;;
			esac
		else
			echo -e "\nChecksums of installed and provided binary match.\n"
			echo -e "Your adb binaries seem to be up to date. Please check https://github.com/simmac/minimal_adb_fastboot for updates or do a git pull!"
			exit 0;
		fi
fi
if [ "$VERSION" != "$VERSIONINSTALLED" ]; then
	echo -e "\nadb is not installed or outdated."
fi
echo -e "The installation process is now starting. Please enter your password if asked for it or press crtl+c to cancel.\n"
read -p "Press [ENTER] to install adb and fastboot."

#INSTALLATION ROUTINE
sudo cp $BINPATH/adb $INSTALLPATH/adb
sudo cp $BINPATH/fastboot $INSTALLPATH/fastboot



#check if installation was successful.
{ VERSIONINSTALLED="$(adb version | cut -d ' '  -f5)"; } &> /dev/null
if [ "$VERSION" == "$VERSIONINSTALLED" ]; then
		echo -e "\nInstallation completed successfully! adb version $VERSIONINSTALLED is now installed."
		exit 0
else
	echo -e "\n\nSorry, something went wrong :( Try again."
	exit 2
fi
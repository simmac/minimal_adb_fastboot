#!/bin/bash
clear
echo -e "\n\nQuick adb/fastboot installer 1.2 .\n"

#Gets location of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#This checks the adb version of the provided bins and the installed adb.
VERSION="$($DIR/bins/./adb version | cut -d ' '  -f5)"
{ VERSIONINSTALLED="$(adb version | cut -d ' '  -f5)"; } &> /dev/null

#This is checking if the installed adb version is up to date.
#If it is, it will quit the script.
if [ "$VERSION" == "$VERSIONINSTALLED" ]; then
		echo -e "It seems, ADB is up to date. However, there could be silent changes which "
		echo -e "didn't increment the version number counter. Do you want to update ADB nevertheless?\n"
		read -p "Please enter y(es) or n(o): " yn
		case $yn in
			[Yy]* ) ;;
			[Nn]* ) echo -e "Quitting...\n\n"; exit 0;;
		esac
fi
if [ "$VERSION" != "$VERSIONINSTALLED" ]; then
	echo -e "\nadb is not installed or outdated."
fi
echo -e "The installation process is now starting. Please enter your password if asked for it or press crtl+c to cancel.\n"
read -p "Press [ENTER] to install adb and fastboot."

#INSTALLATION ROUTINE
sudo cp $DIR/bins/adb /usr/bin/adb
sudo cp $DIR/bins/fastboot /usr/bin/fastboot


#check if installation was successful.
{ VERSIONINSTALLED="$(adb version | cut -d ' '  -f5)"; } &> /dev/null
if [ "$VERSION" == "$VERSIONINSTALLED" ]; then
		echo -e "\nInstallation completed successfully! adb version $VERSIONINSTALLED is now installed."
		exit 0
else
	echo -e "\n\nSorry, something went wrong :( Try again."
	exit 2
fi
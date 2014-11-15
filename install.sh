#!/bin/bash
echo -e "\n\n\n\n\nMinimal adb/fastboot installer 1.0 .\n"

#This checks the adb version of the provided bins and the installed adb.
VERSION="$(bins/./adb version | cut -d ' '  -f5)"
{ VERSIONINSTALLED="$(adbs version | cut -d ' '  -f5)"; } &> /dev/null

#This is checking if the installed adb version is up to date.
#If it is, it will quit the script.
if [ "$VERSION" == "$VERSIONINSTALLED" ]; then
		echo -e "adb is already up to date, no need to update it. \n Quitting..."
		exit 0
fi
echo -e "\nadb is not installed or outdated."
echo -e "adb will now be installed. Please enter your password if asked for it or press crtl+c to cancel.\n"
read -p "Press [ENTER] to install adb and fastboot."

#INSTALLATION ROUTINE
sudo cp bins/adb /usr/bin/adb
sudo cp bins/fastboot /usr/bin/fastboot


#check if installation was successful.
{ VERSIONINSTALLED="$(adb version | cut -d ' '  -f5)"; } &> /dev/null
if [ "$VERSION" == "$VERSIONINSTALLED" ]; then
		echo -e "\nInstallation completed successfully! adb version $VERSIONINSTALLED is now installed."
		exit 0
else
	echo -e "\n\nSorry, something went wrong :( Try again."
	exit 2
fi
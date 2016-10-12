#!/bin/sh

# require functions
. ./common.sh

# CONSTANTS

stockImageDir=stockImage/
deleteGitIgnore $stockImageDir

romExtractionDir=_extracted

# INIT

echo "NETHUNTER LINUX FLASH (STOCK NEXUS GOOGLE IMAGES)\n"
echo "NOTE: THIS WILL FACTORY RESET THE DEVICE (15 secs to cancel using 'ctrl + c')\n"
sleep 15

echo "CHECKING PRE-REQUISITES\n"

doCommonChecks

isProgramInPath unzip

echo "Checking stock image existence"
isEmpty $stockImageDir
echo "Checking stock image existence ...DONE\n"

echo "CHECKING PRE-REQUISITES ...DONE\n"
sleep 3

echo "Creating tmp dir $romExtractionDir"
mkdir $romExtractionDir
echo "Creating tmp dir $romExtractionDir ...DONE\n"

echo "Extracting $(ls $stockImageDir*)"
unzip $stockImageDir* -d $romExtractionDir
echo "Extracting $(ls $stockImageDir*) ...DONE\n"

echo "cd to $romExtractionDir"
cd $romExtractionDir/*
echo "cd to $romExtractionDir ...DONE\n"

echo "Rebooting into bootloader"
adb reboot bootloader
sleep 5
echo "Rebooting into bootloader ...DONE\n"

echo "Flashing stock ROM\n!!!! DONT UNPLUG THE DEVICE !!!!"
./flash-all.sh
echo "Flashing Stock ROM ...DONE\n"

echo "Deleting tmp dir $romExtractionDir"
rm -rf ../../$romExtractionDir
echo "Deleting tmp dir $romExtractionDir ...DONE\n"

# END

echo "The device should be rebooting, once it is booted,"
echo "do the initial setup, enable developer options and USB debugging again.\n"
echo "Next step is flashing TWRP && superSU && Kali Nethunter using twrpFlash.sh script\n"
exit

#!/bin/bash

# require functions
. ./common.sh

# CONSTANTS

kaliNethunterHome=$(pwd)
stockImageDir=stockImage/
deleteGitIgnore $stockImageDir

romExtractionDir=_extracted

# INIT

echo -e "NETHUNTER LINUX FLASH (STOCK NEXUS GOOGLE IMAGES)\n"
echo -e "NOTE: THIS WILL FACTORY RESET THE DEVICE (15 secs to cancel using 'ctrl + c')\n"
sleep 15

echo -e "CHECKING PRE-REQUISITES\n"

doCommonChecks

isProgramInPath unzip

echo -e "Checking stock image existence"
isEmpty $stockImageDir
echo -e "Checking stock image existence ...DONE\n"

echo -e "CHECKING PRE-REQUISITES ...DONE\n"
sleep 3

echo -e "Creating tmp dir $romExtractionDir"
mkdir $romExtractionDir
echo -e "Creating tmp dir $romExtractionDir ...DONE\n"

echo -e "Extracting $(ls $stockImageDir*)"
unzip $stockImageDir* -d $romExtractionDir
echo -e "Extracting $(ls $stockImageDir*) ...DONE\n"

echo -e "cd to $romExtractionDir"
cd $romExtractionDir/*
echo -e "cd to $romExtractionDir ...DONE\n"

echo -e "Rebooting into bootloader"
adb reboot bootloader
sleep 5
echo -e "Rebooting into bootloader ...DONE\n"

echo -e "Flashing stock ROM\n!!!! DONT UNPLUG THE DEVICE !!!!"
./flash-all.sh || fastboot -w update $kaliNethunterHome/$stockImageDir*
echo -e "Flashing Stock ROM ...DONE\n"

echo -e "Deleting tmp dir $romExtractionDir"
rm -rf $kaliNethunterHome/$romExtractionDir
echo -e "Deleting tmp dir $romExtractionDir ...DONE\n"

# END

echo -e "The device should be rebooting, once it is booted,"
echo -e "do the initial setup, enable developer options and USB debugging again.\n"
echo -e "Next step is flashing TWRP && superSU && Kali Nethunter using twrpFlash.sh script\n"
exit

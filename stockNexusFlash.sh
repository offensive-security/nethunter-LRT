#!/bin/sh

# require functions
. ./common.sh

# CONSTANTS

stockImageDir=stockImage/
deleteGitIgnore $stockImageDir

romExtractionDir=_extracted


# INIT

echo -ne "NETHUNTER LINUX FLASH (STOCK NEXUS GOOGLE IMAGES)\n"
echo -ne "NOTE: THIS WILL FACTORY RESET THE DEVICE (15 secs to cancel using 'ctrl + c')\n"
sleep 15
echo -ne "CHECKING PRE-REQUISITES\n"

doCommonChecks

isProgramInPath tar

echo "Checking stock image existence"
isEmpty $stockImageDir
echo -ne "Checking stock rom existence DONE\n"

echo -ne "CHECKING PRE-REQUISITES DONE\n"
sleep 3

echo "Creating tmp dir $romExtractionDir"
mkdir $romExtractionDir
echo -ne "Creating tmp dir $romExtractionDir DONE\n"

echo "Extracting $(ls $stockImageDir*)"
tar -xvf $stockImageDir* -C $romExtractionDir
echo -ne "EXTACTING $(ls $stockImageDir*) DONE\n"

echo "cd to $romExtractionDir"
cd $romExtractionDir/*
echo -ne "cd to $romExtractionDir DONE\n"

echo "Rebooting into bootloader"
adb reboot bootloader
sleep 5
echo -ne "Rebooting into bootloader DONE\n"

echo "Flasing Stock Rom"
echo "!!!! DONT UNPLUG THE DEVICE !!!!"
./flash-all.sh
echo -ne "Flasing Stock Rom DONE\n"

echo "Deleting tmp dir $romExtractionDir"
rm -rf ../../$romExtractionDir
echo -ne "Deleting $romExtractionDir DONE\n"

# END

echo "The device should be rebooting, once it is booted,"
echo -ne "do the initial setup, enable developer options and USB debugging again.\n"
echo -ne "Next step is flashing TWRP && superSU && Kali Nethunter using twrpFlash.sh script\n"
exit

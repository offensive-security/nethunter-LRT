#!/bin/sh

# require functions
. ./common.sh

# CONSTANTS

stockImageDir=stockImage/
deleteGitIgnore $stockImageDir

romExtractionDir=_extracted


# INIT

echo "NETHUNTER LINUX FLASH (STOCK NEXUS GOOGLE IMAGES)"
echo "NOTE: THIS WILL FACTORY RESET THE DEVICE (15 secs to cancel using 'ctrl + c')"
sleep 15
echo "CHECKING PRE-REQUISITES"

doCommonChecks

isProgramInPath tar

echo "Checking stock image existence"
isEmpty $stockImageDir
echo "Checking stock rom existence DONE"

echo "CHECKING PRE-REQUISITES DONE"
sleep 3

echo "Creating tmp dir $romExtractionDir"
mkdir $romExtractionDir
echo "Creating tmp dir $romExtractionDir DONE"

echo "Extracting $(ls $stockImageDir*)"
tar -xvf $stockImageDir* -C $romExtractionDir
echo "EXTACTING $(ls $stockImageDir*) DONE"

echo "cd to $romExtractionDir"
cd $romExtractionDir/*
echo "cd to $romExtractionDir DONE"

echo "Rebooting into bootloader"
adb reboot bootloader
sleep 5
echo "Rebooting into bootloader DONE"

echo "Flasing Stock Rom"
echo "!!!! DONT UNPLUG THE DEVICE !!!!"
./flash-all.sh
echo "Flasing Stock Rom DONE"

echo "Deleting tmp dir $romExtractionDir"
rm -rf ../../$romExtractionDir
echo "Deleting $romExtractionDir DONE"

# END

echo "The device should be rebooting, once it is booted,"
echo "do the initial setup, enable developer options and USB debugging again."
echo "Next step is flashing TWRP && superSU && Kali Nethunter using twrpFlash.sh script"
exit

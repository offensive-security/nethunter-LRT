#!/bin/sh

# CONSTANTS

stockImageDir=stockImage/
romExtractionDir=_extracted

# require functions
. ./common.sh

# INIT

echo "NETHUNTER LINUX FLASH (STOCK NEXUS GOOGLE IMAGES)\n"

echo "CHECKING PRE-REQUISITES\n"

echo "Checking if adb is installed"
isAdbInPath
echo "Checking if adb is installed DONE\n"

echo "Checking if fastboot is installed"
isFastbootInPath
echo "Checking if fastboot is installed DONE\n"

echo "Adb connection check"
isAdbConnected
echo "Adb connection check DONE\n"

echo "Checking stock image existence"
isEmpty $stockImageDir
echo "Checking stock rom existence DONE\n"

echo "CHECKING PRE-REQUISITES DONE\n"
sleep 3

echo "Creating tmp dir $romExtractionDir"
mkdir $romExtractionDir
echo "Creating tmp dir $romExtractionDir DONE\n"

echo "Extracting $(ls $stockImageDir*)"
tar -xvf $stockImageDir* -C _extracted
echo "EXTACTING $(ls $stockImageDir*) DONE\n"

echo "cd to $romExtractionDir"
cd _extracted/*
echo "cd to $romExtractionDir DONE\n"

echo "Rebooting into bootloader"
adb reboot bootloader
sleep 5
echo "Rebooting into bootloader DONE\n"

echo "Flasing Stock Rom\n!!!! DONT UNPLUG THE DEVICE !!!!"
./flash-all.sh
echo "Flasing Stock Rom DONE\n"

echo "Deleting tmp dir $romExtractionDir"
rm -rf ../../$romExtractionDir
echo "Deleting $romExtractionDir DONE\n"

# END

echo "The device should be rebooting, once it is booted,"
echo "do the initial setup, enable developer options and USB debugging again.\n"
echo "Next step is flashing TWRP && superSU && Kali Nethunter using twrpFlash.sh script\n"
exit

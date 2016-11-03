#!/bin/bash

# require functions
. ./common.sh

# CONSTANTS

stockImageDir=stockImage/
deleteGitIgnore $stockImageDir

romExtractionDir=_extracted

# INIT

echo -e "NETHUNTER LINUX FLASH (STOCK OPO Fastboot IMAGES)\n"
echo -e "NOTE: THIS WILL FACTORY RESET THE DEVICE (15 secs to cancel using 'ctrl + c')\n"
sleep 15

echo -e "CHECKING PRE-REQUISITES\n"

doCommonChecks

isProgramInPath unzip

echo -e "Checking stock image existence"
isEmpty $stockImageDir
echo -e "Checking stock image existence ...DONE\n"

opoModelCheck $1

echo -e "CHECKING PRE-REQUISITES ...DONE\n"
sleep 3

echo -e "Creating tmp dir $romExtractionDir"
mkdir -p $romExtractionDir
echo -e "Creating tmp dir $romExtractionDir ...DONE\n"

echo -e "Extracting $(ls $stockImageDir*)"
unzip $stockImageDir* -d  $romExtractionDir
echo -e "Extracting $(ls $stockImageDir*) ...DONE\n"

echo -e "cd to $romExtractionDir"
cd $romExtractionDir/
echo -e "cd to $romExtractionDir ...DONE\n"

echo -e "Rebooting into bootloader"
adb reboot bootloader
sleep 5
echo -e "Rebooting into bootloader ...DONE\n"

echo -e "Flashing stock ROM\n!!!! DONT UNPLUG THE DEVICE !!!!"

fastboot flash sbl1 sbl1.mbn
sleep 3
fastboot flash dbi sdi.mbn
sleep 3
fastboot flash aboot emmc_appsboot.mbn
sleep 3
fastboot reboot-bootloader
sleep 5
fastboot flash modem NON-HLOS.bin
sleep 3
fastboot flash rpm rpm.mbn
sleep 3
fastboot flash tz tz.mbn
sleep 3
fastboot flash LOGO logo.bin
sleep 3
fastboot flash oppostanvbk static_nvbk.bin
sleep 3
fastboot reboot-bootloader
sleep 5
fastboot flash boot boot.img
sleep 3
fastboot flash recovery recovery.img
sleep 3
fastboot erase system
sleep 3
fastboot flash system system.img
sleep 3
fastboot erase userdata
sleep 3
fastboot flash userdata $fUserData
sleep 3
fastboot erase cache
sleep 3
fastboot flash cache cache.img
sleep 3
fastboot continue
echo -e "Flashing stock ROM ...DONE\n"

echo -e "Deleting tmp dir $romExtractionDir"
rm -rf ../$romExtractionDir
echo -e "Deleting tmp dir $romExtractionDir ...DONE\n"

# END

echo -e "The device should be rebooting, once it is booted,"
echo -e "do the initial setup, enable developer options and USB debugging again.\n"
echo -e "Next step is flashing TWRP && superSU && Kali Nethunter using twrpFlash.sh script\n"
exit

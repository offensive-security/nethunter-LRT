#!/bin/sh

# require functions
. ./common.sh

# CONSTANTS

stockImageDir=stockImage/
deleteGitIgnore $stockImageDir

romExtractionDir=_extracted


# INIT

echo "NETHUNTER LINUX FLASH (STOCK OPO Fastboot IMAGES)\n"
echo "NOTE: THIS WILL FACTORY RESET THE DEVICE (15 secs to cancel using 'ctrl + c')\n"
sleep 15
echo "CHECKING PRE-REQUISITES\n"

doCommonChecks

isProgramInPath unzip

echo "Checking stock image existence"
isEmpty $stockImageDir
echo "Checking stock rom existence DONE\n"

opoModelCheck $1

echo "CHECKING PRE-REQUISITES DONE\n"
sleep 3

echo "Creating tmp dir $romExtractionDir"
mkdir $romExtractionDir
echo "Creating tmp dir $romExtractionDir DONE\n"

echo "Extracting $(ls $stockImageDir*)"
unzip $stockImageDir* -d  $romExtractionDir
echo "EXTACTING $(ls $stockImageDir*) DONE\n"

echo "cd to $romExtractionDir"
cd $romExtractionDir/
echo "cd to $romExtractionDir DONE\n"

echo "Rebooting into bootloader"
adb reboot bootloader
sleep 5
echo "Rebooting into bootloader DONE\n"

echo "Flasing Stock Rom\n!!!! DONT UNPLUG THE DEVICE !!!!"

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
echo "Flasing Stock Rom DONE\n"

echo "Deleting tmp dir $romExtractionDir"
rm -rf ../$romExtractionDir
echo "Deleting $romExtractionDir DONE\n"

# END

echo "The device should be rebooting, once it is booted,"
echo "do the initial setup, enable developer options and USB debugging again.\n"
echo "Next step is flashing TWRP && superSU && Kali Nethunter using twrpFlash.sh script\n"
exit

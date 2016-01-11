#!/bin/sh

# require functions
. ./common.sh

# CONSTANTS

# TWRP 
twrpImageDir=twrpImage/
deleteGitIgnore $twrpImageDir
twrpImage="$twrpImageDir"*

# SuperSU
superSuDir=superSu/
deleteGitIgnore $superSuDir
superSuZip="$superSuDir"*
sdSupersu="/sdcard/supersu.zip"

# Kali Nethunter
nhDir=kaliNethunter/
deleteGitIgnore $nhDir
nhZip="$nhDir"*
sdnh="/sdcard/kaliNethunter.zip"


# INIT

echo -ne "NETHUNTER LINUX FLASH (TWRP, SuperSU and Kali Nethunter)\n"

echo -ne "CHECKING PRE-REQUISITES\n"

doCommonChecks

echo "Checking TWRP image existence"
isEmpty $twrpImageDir
echo -ne "Checking TWRP image existence DONE\n"

echo "Checking SuperSu existence"
isEmpty $superSuDir
echo -ne "Checking SuperSu existence DONE\n"

echo "Checking Kali Nethunter zip existence"
isEmpty $nhDir
echo -ne "Checking Kali Nethunter zip existence DONE\n"

echo -ne "CHECKING PRE-REQUISITES DONE\n"
sleep 3

echo "Sending Kali Nethunter zip to the device"
adb push -p $nhZip $sdnh
sleep 3
echo -ne "Sending Kali Nethunter zip to the device DONE\n"

echo "Sending SuperSu zip to the device"
adb push -p $superSuZip $sdSupersu
sleep 3
echo -ne "Sending SuperSu zip to the device DONE\n"

echo "Rebooting into bootloader"
adb reboot bootloader
sleep 5
echo -ne "Rebooting into bootloader DONE\n"

echo "Flashing TWRP image"
fastboot flash recovery $twrpImage
sleep 3
echo -ne "Flashing TWRP image DONE\n"

echo "Booting into TWRP (20 secs dont worry)"
fastboot boot $twrpImage
sleep 20
echo -ne "Booting into TWRP DONE\n"

echo "Installing SuperSU"
adb shell "twrp install $sdSupersu"
echo -ne "Installing SuperSU DONE!\n"

echo "Installing Kali Linux Nethunter"
sleep 5
adb shell "twrp install $sdnh"
echo "Installing Kali Linux Nethunter DONE!"

echo "Rebooting into Kali Linux Nethunter"
sleep 3
adb reboot
echo -ne "Everything is installed. Phone should be booting up! Enjoy\n"
exit


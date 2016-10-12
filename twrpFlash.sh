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

echo "NETHUNTER LINUX FLASH (TWRP, SuperSU and Kali Nethunter)\n"

# Pre-requisites
echo "CHECKING PRE-REQUISITES"

doCommonChecks

echo "Checking TWRP image existence"
isEmpty $twrpImageDir
echo "Checking TWRP image existence ...DONE\n"

echo "Checking SuperSu existence"
isEmpty $superSuDir
echo "Checking SuperSu existence ...DONE\n"

echo "Checking Kali Nethunter zip existence"
isEmpty $nhDir
echo "Checking Kali Nethunter zip existence ...DONE\n"

echo "CHECKING PRE-REQUISITES ...DONE\n"
sleep 3


# File Transfer
echo "Sending Kali Nethunter zip to the device"
adb push -p $nhZip $sdnh 2>/dev/null ||
	adb push $nhZip $sdnh
sleep 3
echo "Sending Kali Nethunter zip to the device ...DONE\n"

echo "Sending SuperSu zip to the device"
adb push -p $superSuZip $sdSupersu 2>/dev/null ||
  adb push $superSuZip $sdSupersu
sleep 3
echo "Sending SuperSu zip to the device ...DONE\n"


# Preparing device
echo "Rebooting into bootloader"
adb reboot bootloader
sleep 5
echo "Rebooting into bootloader ...DONE\n"


# Flashing device
echo "Flashing TWRP image"
fastboot flash recovery $twrpImage
sleep 3
echo "Flashing TWRP image ...DONE\n"


# Restarting
echo "Booting into TWRP (20 secs dont worry)"
fastboot boot $twrpImage
sleep 20
echo "Booting into TWRP ...DONE\n"


# Installing
echo "Installing SuperSU"
adb shell "twrp install $sdSupersu"
echo "Installing SuperSU ...DONE\n"

echo "Installing Kali Linux Nethunter"
sleep 5
adb shell "twrp install $sdnh"
echo "Installing Kali Linux Nethunter ...DONE\n"


# Done!
echo "Rebooting into Kali Linux Nethunter"
sleep 3
adb reboot

echo "\nEverything is installed. Phone should be booting up! Enjoy Nethunter\n"
exit

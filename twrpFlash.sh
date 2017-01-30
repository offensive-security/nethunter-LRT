#!/bin/bash

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

echo -e "NETHUNTER LINUX FLASH (TWRP, SuperSU and Kali Nethunter)\n"

# Pre-requisites
echo -e "CHECKING PRE-REQUISITES"

doCommonChecks

echo -e "Checking TWRP image existence"
isEmpty $twrpImageDir
echo -e "Checking TWRP image existence ...DONE\n"

echo -e "Checking SuperSu existence"
isEmpty $superSuDir
echo -e "Checking SuperSu existence ...DONE\n"

echo -e "Checking Kali Nethunter zip existence"
isEmpty $nhDir
echo -e "Checking Kali Nethunter zip existence ...DONE\n"

echo -e "CHECKING PRE-REQUISITES ...DONE\n"
sleep 3


# File Transfer
echo -e "Sending Kali Nethunter zip to the device"
adb push -p $nhZip $sdnh 2>/dev/null ||
	adb push $nhZip $sdnh
sleep 3
echo -e "Sending Kali Nethunter zip to the device ...DONE\n"

echo -e "Sending SuperSu zip to the device"
adb push -p $superSuZip $sdSupersu 2>/dev/null ||
  adb push $superSuZip $sdSupersu
sleep 3
echo -e "Sending SuperSu zip to the device ...DONE\n"


# Preparing device
echo -e "Rebooting into bootloader"
adb reboot bootloader
sleep 5
echo -e "Rebooting into bootloader ...DONE\n"


# Flashing device
echo -e "Flashing TWRP image"
fastboot flash recovery $twrpImage
sleep 3
echo -e "Flashing TWRP image ...DONE\n"


# Restarting
echo -e "Booting into TWRP (20 secs dont worry)"
fastboot boot $twrpImage
sleep 20
echo -e "Booting into TWRP ...DONE\n"

read -n1 -r -p "Press any key when you're ready..." key


# Installing
echo -e "Installing SuperSU"
adb shell "twrp install $sdSupersu"
echo -e "Installing SuperSU ...DONE\n"

echo -e "Installing Kali Linux Nethunter"
sleep 5
adb shell "twrp install $sdnh"
echo -e "Installing Kali Linux Nethunter ...DONE\n"


# Done!
echo -e "Rebooting into Kali Linux Nethunter"
sleep 3
adb reboot

echo -e "\nEverything is installed. Phone should be booting up! Enjoy Nethunter\n"
exit

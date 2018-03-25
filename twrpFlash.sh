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

# Kali Nethunter Kernel
nhkDir=kaliNethunterKernel/
deleteGitIgnore $nhkDir
nhkZip="$nhkDir"*
sdnhk="/sdcard/kaliNethunterKernel.zip"

# INIT

echo -e "NETHUNTER LINUX FLASH (TWRP, SuperSU and Kali Nethunter)\n"

# Pre-requisites
echo -e "CHECKING PRE-REQUISITES"

doCommonChecks

isProgramInPath tar

checkTwrpImageExistence

echo -e "Checking SuperSu existence"
isEmpty $superSuDir
echo -e "Checking SuperSu existence ...DONE\n"

echo -e "Checking Kali Nethunter zip existence"
isEmpty $nhDir
echo -e "Checking Kali Nethunter zip existence ...DONE\n"

echo -e "Checking Kali Nethunter Kernel zip existence"
isEmptyCheck $nhkDir
shouldInstallNHK=$(echo $?)
if [[ $shouldInstallNHK -eq 1 ]]
then
    echo -e "Dir $nhkDir has files"
else
    echo -e "Dir $nhkDir has no files"
fi
echo -e "Checking Kali Nethunter Kernel zip existence ...DONE\n"

echo -e "CHECKING PRE-REQUISITES ...DONE\n"
sleep 3


# File Transfer
echo -e "Sending Kali Nethunter zip to the device"
adb push -p $nhZip $sdnh 2>/dev/null ||
    adb push $nhZip $sdnh
sleep 3
echo -e "Sending Kali Nethunter zip to the device ...DONE\n"

if [[ $shouldInstallNHK -eq 1 ]]
then
    echo -e "Sending Kali Nethunter Kernel zip to the device"
    adb push -p $nhkZip $sdnhk 2>/dev/null ||
	adb push $nhkZip $sdnhk
    sleep 3
    echo -e "Sending Kali Nethunter Kernel zip to the device ...DONE\n"
fi

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

promptAnyKey


# Installing
echo -e "Installing SuperSU"
adb shell "twrp install $sdSupersu"
echo -e "Installing SuperSU ...DONE\n"

echo -e "Installing Kali Linux Nethunter"
sleep 5
adb shell "twrp install $sdnh"
echo -e "Installing Kali Linux Nethunter ...DONE\n"

if [[ $shouldInstallNHK -eq 1 ]]
then
    echo -e "Kali Nethunter Kernel zip exists and will be installed"
    echo -e "Press any key when back in TWRP"
    promptAnyKey
    echo -e "Installing Kali Linux Nethunter Kernel"
    sleep 5
    adb shell "twrp install $sdnhk"
    echo -e "Installing Kali Linux Nethunter Kernel ...DONE\n"
fi

# Done!
echo -e "Rebooting into Kali Linux Nethunter"
sleep 3
adb reboot

echo -e "\nEverything is installed. Device should be booting up! Enjoy Nethunter\n"
exit

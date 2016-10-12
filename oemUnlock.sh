#!/bin/sh

# require functions
. ./common.sh

# INIT
echo "NETHUNTER LINUX FLASH (OEM UNLOCK)\n"
echo "NOTE: THIS WILL FACTORY RESET THE DEVICE (15 secs to cancel using 'ctrl + c')\n"
sleep 15
echo "CHECKING PRE-REQUISITES\n"

doCommonChecks

echo "CHECKING PRE-REQUISITES ...DONE\n"
sleep 3

echo "Rebooting into bootloader"
adb reboot bootloader
sleep 5
echo "Rebooting into bootloader ...DONE\n"

echo "Starting OEM UNLOCK"
echo "This needs you interaction. Check phone screen."
fastboot oem unlock
fastboot flashing unlock
echo "OEM UNLOCK ...DONE\n"

echo "Rebooting the phone"
fastboot continue
echo "Rebooting the phone ...DONE\n"

# END

echo "It can take a bit to boot up, dont worry. ^^\n"
echo "You will need to enable developer options and USB debugging again.\n"

echo "You can flash a stock rom using stockFlash.sh (Not needed if you are in latest android version)"
echo "or continue flashing TWRP && superSU && Kali Nethunter using twrpFlash.sh script\n"
exit

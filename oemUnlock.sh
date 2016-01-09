#!/bin/sh

# require functions
. ./common.sh

# INIT
echo "NETHUNTER LINUX FLASH (OEM UNLOCK)"
echo "NOTE: THIS WILL FACTORY RESET THE DEVICE (15 secs to cancel using 'ctrl + c')"
sleep 15
echo "CHECKING PRE-REQUISITES"

doCommonChecks

echo "CHECKING PRE-REQUISITES DONE"
sleep 3

echo "Rebooting into bootloader"
adb reboot bootloader
sleep 5
echo "Rebooting into bootloader DONE"

echo "Starting OEM UNLOCK"
echo "This needs you interaction. Check phone screen."
fastboot oem unlock
echo "OEM UNLOCK DONE"

echo "Rebooting the phone"
fastboot continue
echo "Rebooting the phone DONE"




echo "It can take a bit to boot up, dont worry. ^^"
echo "You will need to enable developer options and USB debugging again."

echo "You can flash a stock rom using stockFlash.sh (Not needed if you are in latest android version)"
echo "or continue flashing TWRP && superSU && Kali Nethunter using twrpFlash.sh script"
exit

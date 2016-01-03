# Kali Nethunter Linux Root Toolkit (LRT)


The **Nethunter Linux Root Toolkit** is a collection of bash scripts scripts which setup and install Kali Linux Nethunter from Linux and OS X (Mac OS), onto a [NetHunter supported device](https://github.com/offensive-security/kali-nethunter/wiki#10-supported-devices-and-roms).


## Installation Prerequisites

 - USB debugging enabled on the phone.
 - USB debugging RSA fingerprint aproved for the computer.
 - `adb` and `fastboot` installed and present in `$PATH`
 - `tar && unzip` installed and present in `$PATH`
 
*Use google if you don't know how to install adb or fastboot, Android SDK is the best way also you can use this binaries: http://tools.android.com/download.*

**Assumptions:** The device is normally booted, USB debugging enabled and plugged to the Linux machine via USB cable.

**IMPORTANT NOTE**: To ensure a hassle free installation, use USB 2.0 ports during the installation. If installations fail inexplicably, it's most likely USB version standard issues. We use a powered USB 2.0 hub to connect our OPO to a computer during installations!

## LRT Setup Instructions

1. Clone the repository and `cd` to the `Nethunter-LRT/` folder.

2. Download the correct Factory Image for your device and put it in the folder `/stockImage`:
    -  *Nexus devices:* from [Google Nexus Images](https://developers.google.com/android/nexus/images?hl=en)
    -  *OnePlusOne:* from [cyngn.com](https://cyngn.com/support) (donwload the fastboot one)
 
3. Download the correct TWRP image for your device from [TWRP WEB](https://twrp.me/Devices/) and put it in the folder `/twrpImage`

4. Download Latest SuperSu (BETA) from [XDA_Chainfire post](http://forum.xda-developers.com/showpost.php?p=64161125&postcount=3) and put it in the folder `/superSu`

5. Put the nethunter zip (Atm you need to build it see [Latest nethunter build instructions](https://github.com/offensive-security/kali-nethunter/tree/newinstaller-fj/AnyKernel2)) in the folder `/kaliNethunter`

Don't rename or decompress downloaded zip files or images, the script will handle it.


-----------------


OEM Unlock:
---------------
This script is cross device. (Nexus and OnePlus)

Unlock any nexus/OP device using the script `oemUnlock.sh`

This script needs to be launched like `./oemUnlock.sh`.

Is the first thing you will need to do in any new device.

Skip this if your phone bootloader is already unlocked.


Nexus Flash Stock:
---------------
(Only nexus)

The script `stockNexusFlash.sh` will flash the google factory image in the device. 

This script needs to be launched like `./stockNexusFlash.sh`.

This way you will get a clean phone to install nethunter on it. (This will delete all the device data)

Skip this if your phone has a clean flash done/ or you are using other rom.


OPO Flash Stock:
---------------
(Only OnePlusOne)

The script `stockOpoFlash.sh` will flash the opo factory image in the device. 

This script needs to be launched like `./stockOpoFlash.sh 16gb` for the 16GB version or `./stockOpoFlash.sh 64gb` for the 64GB version.

This way you will get a clean phone to install nethunter on it. (This will delete all the device data)

Skip this if your phone has a clean flash done/ or you are using other rom.

Don't forget to make sure your phone is in Developer mode, and you have accepted the RSA Key Dialog.

Custom Recovery (TWRP) + SuperSU (root) + Kali Linux Nethunter
-------------------------------------

This script is cross device. (Nexus and OnePlus)

Should be runned on top of a clean rom install.

The script `twrpFlash.sh`  will flash the custom recovery, superSU and Kali Linux Nethunter.

This script needs to be launched like `./twrpFlash.sh`.

The script will install automatically everything needed for nethunter.

If you using an Aroma version of the Kali Linux Nethunter zip, you will need to do a little interaction with the installer,
then the script will end the installation and reboot the phone.

Don't forget to make sure your phone is in Developer mode, and you have accepted the RSA Key Dialog.


<br>
<hr>

More info: Read the source ^^.

LICENSE: 

> GPL2

DISCLAIMER: 

> This scripts are distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY, to the extent permitted by law; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. (Don't blame me if something doesn't work/goes wrong ^^) Pull requests are welcome.

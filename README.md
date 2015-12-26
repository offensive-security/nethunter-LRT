# nethunter-LRT


The **Nethunter Linux Root Toolkit** is a little collection of scripts to do some common things needed to **install Kali Linux Nethunter from Linux**.


***Tools needed:*** 

 - USB debugging enabled in the phone.
 - `adb` installed and present in `$PATH`
 - `fastboot` installed and present in `$PATH`
 - `tar && unzip` installed and present in `$PATH`
 
*Use google if you don't know how to install adb or fastboot, Android SDK is the best way imo.*

**Assumptions:** The device is normally booted, USB debugging enabled and plugged to the Linux machine via USB cable.

**How to make this work:**

1. Clone the repository and `cd` to the `Nethunter-LRT/` folder.

2. Download the correct Factory Image for your device and put it in the folder `/stockImage`:
    -  *Nexus devices:* from [Google Nexus Images](https://developers.google.com/android/nexus/images?hl=en)
    - *OnePlusOne:*  from [cyngn.com](https://cyngn.com/support) (donwload the fastboot one)
 
3. Download the correct TWRP image for your device from [TWRP WEB](https://twrp.me/Devices/) and put it in the folder `/twrpImage`

4. Download Latest SuperSu (BETA) from [XDA_Chainfire post](http://forum.xda-developers.com/showpost.php?p=64161125&postcount=3) and put it in the folder `/superSu`

5. Put the nethunter zip (Atm you need to build it see [Latest nethunter build instructions](https://github.com/offensive-security/kali-nethunter/tree/newinstaller-fj/AnyKernel2)) in the folder `/kaliNethunter`

Now you are ready ^^.

-----------------
OEM Unlock:
---------------
This script is cross device. (Nexus and OnePlus)

Unlock any nexus/OP device using the script `oemUnlock.sh`

Is the first thing you will need to do in any new device.

Skip this if your phone bootloader is already unlocked.

-----------------
Nexus Flash Stock:
---------------
(Only nexus)
The script `stockNexusFlash.sh` will flash the google factory image in the device. 

This way you will get a clean phone to install nethunter on it. (This will delete all the device data)

Skip this if your phone has a clean flash done/ or you are using other rom.

-----------------
OPO Flash Stock:
---------------
(Only OnePlusOne)

The script `stockOpoFlash.sh` will flash the opo factory image in the device. 

This way you will get a clean phone to install nethunter on it. (This will delete all the device data)

Skip this if your phone has a clean flash done/ or you are using other rom.

-----------------
Custom Recovery (TWRP) + SuperSU (root) + Kali Linux Nethunter
-------------------------------------

This script is cross device. (Nexus and OnePlus)

The script `twrpFlash.sh`  will flash the custom recovery and push the needed files to the phone.

Once you are in the TWRP recovery you will need to flash both zips using the flash utility in TWRP.


-----------------
More info: Read the source ^^.

LICENSE: 

> No licensed, do whatever you want with this.

DISCLAIMER: 

> This scripts are distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY, to the extent permitted by law; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. (Don't blame me if something doesn't work/goes wrong ^^) Pull requests are welcome.
# Kali NetHunter Linux Root Toolkit (LRT)
---------------

The **NetHunter Linux Root Toolkit** is a collection of bash scripts that setup and install Kali Linux NetHunter from a Linux/OSX environment onto a [NetHunter supported device](https://github.com/offensive-security/kali-nethunter/wiki#10-supported-devices-and-roms).

##1. Installation Prerequisites
---------------
 - USB debugging enabled on the phone.
 - USB debugging RSA fingerprint approved for the computer.
 - `adb` and `fastboot` installed and present in `$PATH`
 - `tar && unzip` installed and present in `$PATH`

*Use google if you don't know how to install adb or fastboot; the Android SDK is the best way although you can also use the binaries available at: http://tools.android.com/download.*

**Assumptions:** The device is normally booted, USB debugging is enabled, and the device is plugged into the Linux/OSX machine via a USB cable.

**IMPORTANT NOTE**: To ensure a hassle free installation, use USB 2.0 ports during the installation. When installations fail inexplicably, it's most likely a USB version standard issue. We use a powered USB 2.0 hub to connect our OPO to a computer during installation.

##2. LRT Setup Instructions
---------------
1. Clone this repository and `cd` to the `Nethunter-LRT/` folder.

2. Download the correct Factory Image for your device and put it in the folder `/stockImage`:
    -  *Nexus devices:* from [Google Nexus Images](https://developers.google.com/android/nexus/images?hl=en)
    -  *OnePlusOne:* from [cyngn.com](https://cyngn.com/support) (donwload the fastboot version for your device)

3. Download the correct TWRP image for your device from [TWRP WEB](https://twrp.me/Devices/) and put it in the folder `/twrpImage`

4. Download the latest SuperSu (BETA) from [XDA_Chainfire post](http://forum.xda-developers.com/showpost.php?p=64161125&postcount=3) and put it in the folder `/superSu`

5. Put the NetHunter zip image you downloaded or built in the `/kaliNethunter` folder.

NOTE: Don't rename or decompress the downloaded zip files or images. The scripts will handle it for you.


###2.1 OEM Unlock:
---------------
If your device needs to be unlocked, you can use this script (for both Nexus and OnePlus devices). Skip this if your phone bootloader is already unlocked.

The unlock script needs to be launched like so: `./oemUnlock.sh`.



###2.2 Flash Stock:
---------------
####Nexus Flash Stock (For Nexus devices only)
To flash your Nexus device back to the stock image, use the `stockNexusFlash.sh` script. This way, you will get a clean phone to install NetHunter on. **This will delete all existing device data**.

This script needs to be launched like so: `./stockNexusFlash.sh`.

Once your phone is flashed, don't forget to make sure it's in Developer mode and you have accepted the RSA Key Dialog.


####OPO Flash Stock (For OnePlus One devices only)
To flash your OnePlus One device back to the stock image, use the `stockOpoFlash.sh` script. This way, you will get a clean phone to install NetHunter on. **This will delete all existing device data**.

This script needs to be launched like `./stockOpoFlash.sh 16gb` for the 16GB version or `./stockOpoFlash.sh 64gb` for the 64GB version.

Once your phone is flashed, don't forget to make sure it's in Developer mode and you have accepted the RSA Key Dialog.


###2.3 Custom Recovery (TWRP) + SuperSU (root) + Kali Linux NetHunter
-------------------------------------

This script will install TWRP, SuperSU, and flash Kali NetHunter on your Nexus or OnePlus device. This should be run on top of a clean ROM install.

This script needs to be launched like so: `./twrpFlash.sh`.

If you are using an Aroma version of the Kali Linux NetHunter zip, you will need to do a little interaction with the installer, then the script will end the installation and reboot the phone.

###3.0 Rejoice in your newly installed NetHunter
-------------------------------------

Be joyful and merry! You have now finished installing NetHunter on your phone and are ready for world domination. Check out some of our [NetHunter Post Installation tips](https://github.com/offensive-security/kali-nethunter/wiki#50-post-installation-setup) to get started.

**DISCLAIMER**

> These scripts are distributed in the hope that they will be useful, but WITHOUT ANY WARRANTY, to the extent permitted by law; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. Pull requests are welcome.

import time
import os


def oem_unlock(adb,fastboot):
    print("Rebooting into bootloader")
    os.system(adb + " reboot bootloader")
    time.sleep(5)
    print("Starting OEM UNLOCK")
    print("This needs you interaction. Check phone screen.")
    os.system(fastboot + " oem unlock")
    os.system(fastboot + " flashing unlock")
    print("Rebooting the phone")
    os.system(fastboot + " continue")
    print("Rebooting the phone DONE")
    print("You will need to enable developer options and USB debugging again")
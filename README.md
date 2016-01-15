# Kali NetHunter Linux Root Toolkit (LRT)

* NOTE * This is a python/alpha version.  It's very rough and needs testing/exception handling/cleaning.

The ** NetHunter Linux Root Toolkit ** is a python script which will parse a JSON file to download latest: ADB, Fastboot, TWRP, Factory, and Nethunter files. 

It attempts to then install everything in one simple process so you don't have to hunt down all the necessary files.

## Prerequisites

- Python 2.7
- Python package (Mechanize) - Used for downloading TWRP images
- PIP (to install Mechanize)
- Linux/OSX (maybe windows?)
- Internet Connection

## How to use

```bash
git clone https://github.com/offensive-security/nethunter-LRT.git -b python-installer
cd nethunter-LRT
pip install -r requirements.txt
python lrt.py
```

All of these steps are automated:

(1) Select your device
(2) Select version to install
(3) Download all files
(4) OEM Unlock
(5) Flash factory (then enable adb)
(6) Flash TWRP/SuperSU/Nethunter

But they should be followed in order.

#!/bin/sh


# HELP FUNCTIONS

isAdbInPath () {
    command -v adb >/dev/null 2>&1 && echo "adb FOUND" || { echo >&2 "We require adb but it's not installed/in path.\nAborting."; exit 1; }
}

isFastbootInPath () {
    command -v fastboot >/dev/null 2>&1 && echo "fastboot FOUND" || { echo >&2 "We require fastboot but it's not installed/in path.\nAborting."; exit 1; }
}

isEmpty () { 
    files=$1
    if find $files -maxdepth 0 -empty | read v; then echo "Dir $1 is empty. Files are missing\nAborting."; exit 1; else echo "Dir $1 has files"; fi
}

isAdbConnected () {
	adbGoodState="device"
    adbState=$(adb get-state)
    if [ "$adbState" = "$adbGoodState" ] ; then echo "ADB device detected."; else echo "ADB DEVICE NOT DETECTED!!!\nAborting."; exit 1; fi
}

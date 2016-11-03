#!/bin/bash

# HELP FUNCTIONS

isProgramInPath () {
	echo -e "Checking if $1 is installed"
    command -v $1 >/dev/null 2>&1 && echo -e "$1 FOUND" || { echo -e >&2 "We require $1 but it's not installed/in path.\nAborting."; exit 1; }
    echo -e "Checking if $1 is installed ...DONE\n"
}

deleteGitIgnore () {
    rm -rf $1.gitignore
}

isEmpty () {
    if find $1 -maxdepth 0 -empty | read v; then echo -e "Dir $1 is empty. Files are missing\nAborting."; exit 1; else echo -e "Dir $1 has files"; fi
}

isAdbConnected () {
    adbState=$(adb get-state)
    if [ "$adbState" = "device" ] || [ "$adbState" = "recovery" ] ; then echo -e "ADB device detected."; else echo -e "ADB DEVICE NOT DETECTED!!!\nAborting."; exit 1; fi
}

opoModelCheck () {
    opo16="16gb"
    opo64="64gb"
    if [ -z "$1" ]
        then
            echo -e "No model supplied\nAborting."
            exit 1
        else
            if [ "$1" = "$opo16" ] || [ "$1" = "$opo64" ] ; then echo -e "Using $1 userData for flash"; else echo -e "Model argument found but invalid ($1), check the README!!!\nAborting."; exit 1; fi
            if [ "$1" = "$opo16" ] ; then fUserData="userdata.img"; fi
            if [ "$1" = "$opo64" ] ; then fUserData="userdata_64G.img"; fi
    fi
}

doCommonChecks () {
    isProgramInPath adb

    isProgramInPath fastboot

    echo -e "Adb connection check"
    isAdbConnected
    echo -e "Adb connection check ...DONE\n"
}

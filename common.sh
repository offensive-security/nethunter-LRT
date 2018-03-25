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

isEmptyCheck () {
    find $1 -maxdepth 0 -empty | read v
    return $?
}

isEmpty () {
    if isEmptyCheck $1; then echo -e "Dir $1 is empty. Files are missing\nAborting."; exit 1; else echo -e "Dir $1 has files"; fi
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

isFileExtension () {
    local status

    echo -e "Checking if $1 is $2 file extension"
    if [[ $1 == *$2 ]]
    then
	status=$?
	echo -e "...YES"
    else
	status=$?
	echo -e "...NO"
    fi
    echo -e "Checking if $1 is $2 file extension ...DONE\n"

    return $status
}

extractTar () {
    echo -e "Extracting $1"
    tar -x -f $1 --one-top-level=$twrpImageDir
    echo -e "Extracting $1 ...DONE\n"
}

deleteAllTars () {
    echo -e "Deleting all tars in $1"
    rm $1
    echo -e "Deleting all tars in $1 ...DONE\n"
}

checkTwrpImageExist () {
    echo -e "Checking TWRP image existence"
    isEmpty $twrpImageDir
    echo -e "Checking TWRP image existence ...DONE\n"
}

checkTwrpImageExistence () {
    checkTwrpImageExist

    if isFileExtension $twrpImage ".tar"
    then
	extractTar $twrpImage
	deleteAllTars $twrpImageDir*.tar
    fi

    checkTwrpImageExist
    if ! isFileExtension $twrpImage ".img"
    then
	echo -e "RECOVERY IMAGE IS NOT AN .img FILE!!!\nAborting."
	exit 1
    fi
}

promptAnyKey () {
    read -n1 -r -p "Press any key when you're ready..." key
}

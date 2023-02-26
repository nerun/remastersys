#!/bin/bash

# Color codes, "f" means "font"
declare -r fLightRed="\e[91m"
declare -r fLightGreen="\e[92m"
declare -r fLightYellow="\e[93m"
declare -r fLightBlue="\e[94m"
declare -r fLightMagenta="\e[95m"
declare -r fLightCyan="\e[96m"
declare -r fRed="\e[31m"
declare -r fGreen="\e[32m"
declare -r fYellow="\e[33m"
declare -r fBlue="\e[34m"
declare -r fMagenta="\e[35m"
declare -r fCyan="\e[36m"
declare -r fOrange="\e[38;5;214m"

# Style codes
declare -r fB="\e[1m" # bold
declare -r fI="\e[3m" # italic

# ENDING: Reset all attributes
declare -r fEND="\e[0m"

# help files
function GiveUserHelp(){
    local locale_code=$(locale -a | tail -1 | cut -d'.' -f1)

    if [ -f /etc/remastersys/remastersys-help-"$locale_code".txt ]; then
        local help_file="/etc/remastersys/remastersys-help-$locale_code.txt"
    else
        local help_file="/etc/remastersys/remastersys-help.txt"
    fi

    cat "$help_file"

    exit 0
}

# check if running with root privileges
function IsRoot(){
    if [ $(whoami) != "root" ]; then
        echo -e $"$fB$fRed\n$Superuser\n$fEND"
        exit 1
    fi
}

# Replacement for "which XX" that gives answer 'XX not found'
function find_bin(){
    find /usr/bin /usr/sbin -name "$1"
}

# If remastersys.conf is incorrect or missing, set standards
function SettingsIntegrityCheck(){
    if [ -f /etc/remastersys.conf ]; then
        if [ "$BASEWORKDIR" = "" ]; then
            BASEWORKDIR="/home"
        fi

        if [ "$WORKDIR" = "" ]; then
            WORKDIR="/home/remastersys"
        fi

        if [ "$LIVEUSER" = "" ]; then
            LIVEUSER="live"
        fi

        # live username in lowercase
        LIVEUSER="$(echo $LIVEUSER | awk '{print tolower ($0)}')"
        LIVEUSER_FULL_NAME="$LIVEUSER session user"

        if [ "$LIVECDLABEL" = "" ]; then
            LIVECDLABEL="Remastersys"
        fi

        if [ "$CUSTOMISO" = "" ]; then
            CUSTOMISO="remastersys-livecd.iso"
        fi

        if [ $(echo "$ISOBOOT" | awk '{print toupper ($0)}') = "ISOLINUX" ]; then
            ISOBOOT="ISOLINUX"
        else
            # Including: "" and "grub"
            ISOBOOT="GRUB"
        fi

        if [ "$SQUASHFSOPTS" = "" ]; then
            SQUASHFSOPTS="-no-recovery -always-use-fragments -b 1M -comp zstd"
        fi

        SHOWICON="$(echo $SHOWICON | awk '{print tolower ($0)}')"

        if [[ "$SHOWICON" == @("0"|"no"|"n"|"false") ]]; then
            SHOWICON="0"
        else
            # Including: "" and "1"
            SHOWICON="1"
        fi
    else
        echo """# Remastersys Global Configuration File.

# This is the temporary working directory and won't be included on the CD/DVD.
BASEWORKDIR=\"/home\"
WORKDIR=\"/home/remastersys\"

# Here you can add any other files or directories to be excluded from the live
# file system. Separate each entry with a space.
EXCLUDES=\"\"

# Here you can change the Live CD/DVD username.
LIVEUSER=\"live\"

# Here you can change the name of the Live CD/DVD label.
LIVECDLABEL=\"Remastersys\"

# Here you can change the name of the ISO file that is created.
CUSTOMISO=\"remastersys-livecd.iso\"

# Here you can change the boot method for the live: GRUB or ISOLINUX.
ISOBOOT=\"GRUB\"

# Options for mksquashfs.
# Default is: \"-no-recovery -always-use-fragments -b 1M -comp zstd\"
SQUASHFSOPTS=\"-no-recovery -always-use-fragments -b 1M -comp zstd\"

# Option to show install icon on live desktop in dist mode:
# 1=yes or true, 0=no or false.
SHOWICON=\"1\"""" > /etc/remastersys.conf
    fi
}

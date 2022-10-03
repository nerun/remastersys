#!/bin/bash

# SYSTEM LOCALIZATION
# Target to file:
# /usr/share/locale/(language code)/LC_MESSAGES/libremastersys.sh.mo
TEXTDOMAIN=libremastersys.sh

# VARIABLES ####################################################################

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

# IsRoot
Superuser="ERROR: This script must run as superuser. Try with \"sudo\"."

# FUNCTIONS ####################################################################

# help files
function GiveUserHelp(){
    local locale_code=$(locale -a | tail -1 | cut -d'.' -f1)

    if [ -f /etc/remastersys/remastersys-help-"$locale_code".txt ]; then
        local help_file="/etc/remastersys/remastersys-help-$locale_code.txt"
    else
        local help_file="/etc/remastersys/remastersys-help.txt"
    fi

    less -FX "$help_file"

    exit 0
}

# check if running with root privileges
function IsRoot(){
    if [ $(whoami) != "root" ]; then
        echo -e $"$fB$fRed\n$Superuser\n$fEND"
        exit 1
    fi
}


#!/bin/bash

# SYSTEM LOCALIZATION
# Target to file:
# /usr/share/locale/(language code)/LC_MESSAGES/libremastersysgui.sh.mo
TEXTDOMAIN=libremastersysgui.sh

# LIBRARIES
# loads $Superuser
. /usr/lib/remastersys/libremastersys.sh

declare -r Pick=$"Options"
declare -r Size=$"Size"
declare -r Info=$"Info"
declare -r Cancel=$"Cancel"
declare -r Quit=$"Quiting now."
declare -r Continue=$"\n\nClick OK to continue."
declare -r Return=$"\n\nClick OK to return to previous menu."

# NOTE: attribute --fixed do not allows to use --width or --height
declare -r DIALOG="$(which yad) --window-icon=/usr/share/icons/hicolor/16x16/apps/remastersys.png --center --always-print-result --dialog-sep --image=/usr/share/icons/hicolor/48x48/apps/remastersys.png"
# Cancel / Ok buttons are the default when --button is not provided
declare -r MSGBOX="--button=Ok:0"
declare -r MENU="--list --column=$Pick --column=$Info"
declare -r MENU_1="--list --column=$Pick --column=$Size --column=$Info"

# remember to declare $TITLETEXT before load this library
declare -r DIALOG_0="$DIALOG --fixed"
declare -r DIALOG_1="$DIALOG --fixed --text="
declare -r DIALOG_1_nf="$DIALOG --text="
declare -r DIALOG_2="$DIALOG --fixed $MSGBOX --text="
declare -r DIALOG_2_nf="$DIALOG $MSGBOX --text="

# check if running with root privileges
function IsRootDialog(){
    if [ $(whoami) != "root" ]; then
        $DIALOG_1"$Supersuser"
        exit 1
    fi
}

function QuitNow(){
    if [ $? != 0 ]; then
        # $1 = $TITLETEXT
        $DIALOG_2_nf"$Quit" --width=310 --title="$1"
        exit 0
    fi
}


#!/bin/bash
#
#
#  remastersys-installer is an alternative installer for remastered livecd/dvd's
#
#
#  Created by Tony "Fragadelic" Brijeski
#
#  Copyright 2008-2012 Under the GNU GPL2 License
#
#  Originally Created September 12th,2008
#  Updated to replace zenity with yad July 2012
#
#
#

#  This script requires either yad or dialog to run
#

# checking to make sure script is running with root privileges

testroot="`whoami`"

if [ "$testroot" != "root" ]; then
echo " Must be run as root - exiting"
exit 1
fi

# set options depending on mode - text or gui

testdialog=`which dialog`
DIALOG="`which dialog`"
HEIGHT="17"
WIDTH="50"
MENUHEIGHT="12"
TITLE="--title "
TEXT=""
ENTRY="--inputbox "
MENU="--menu"
YESNO="--yesno "
MSGBOX="--msgbox "
PASSWORD="--passwordbox "
PARTITIONPROG="cfdisk"
TITLETEXT="Remastersys Live Installer"

if [ "$1" = "gui" -o "$2" = "gui" ]; then
GUI="$DISPLAY"
fi

if [ "$GUI" != "" ]; then

testyad=`which yad`

if [ "$testyad" = "" ]; then
echo " Yad not present - proceeding to install yad"
apt-get -y -q install yad
testyad=`which yad`
fi

testgparted=`which gparted`
if [ "$testgparted" = "" ]; then
echo " Gparted not present - proceeding to install gparted"
apt-get -y -q install gparted
fi


if [ "$testyad" != "" ]; then
DIALOGMENU="`which yad` --window-icon=/usr/share/pixmaps/remastersys-installer.png --width=600 --height=400 --center"
DIALOG="`which yad` --window-icon=/usr/share/pixmaps/remastersys-installer.png --center"
TITLE="--always-print-result --dialog-sep --image=/usr/share/pixmaps/remastersys-installer.png --title="
TEXT="--text="
ENTRY="--entry "
ENTRYTEXT="--entry-text "
MENU="--list --column=Pick --column=Info"
YESNO=" --button=Yes:0 --button=No:1 "
MSGBOX=" --button=Ok:0 "
PASSWORD="--entry --hide-text "
testgparted=`which gparted`
if [ "$testgparted" = "" ]; then
PARTITIONPROG="xterm -e cfdisk"
else
PARTITIONPROG="gparted"
fi
TITLETEXT="Remastersys Live Installer"
fi



fi

if [ "$DIALOG" = "" ]; then
echo "Cannot find dialog or zenity.  Exiting."
exit 1
fi

progressbar () {
tail -f /usr/bin/remastersys-installer | $DIALOG $TITLE"$TITLETEXT" $TEXT"$@" --no-buttons --progress --pulsate --auto-close
}



. /etc/live/config.conf
. /etc/remastersys.conf
if [ "$LIVECDLABEL" != "" ]; then
TITLETEXT="$LIVECDLABEL Installer"
fi


if [ "$GUI" = "" ]; then

#
#TEXT MODE#########################################################################################################################################
#
#inform them what this is and ask if they want to continue

$DIALOG $TITLE"$TITLETEXT" $YESNO $TEXT"This is the live installer.\n\nDo you want to continue?" $HEIGHT $WIDTH

if [ $? != 0 ]; then
exit 0
fi

$DIALOG $TITLE"$TITLETEXT" $YESNO $TEXT"The Live Installer will use the US English locale and keyboard layout by default.\n\nWould you like to install with different locale and keyboard settings?\n\nThe Installer itself will still use English." $HEIGHT $WIDTH

if [ $? = 0 ]; then

dpkg-reconfigure locales
dpkg-reconfigure console-data
#dpkg-reconfigure console-setup
dpkg-reconfigure keyboard-configuration

fi

$DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"We need to prepare a swap and install partition now.\n\n$PARTITIONPROG will allow you to create the new partitions.\n\nYou must create or have 1 install partition and 1 swap partition.\n\nIf you already have partitions setup then just quit $PARTITIONPROG and installation will continue.\n\nClick OK to continue." $HEIGHT $WIDTH

#choose the drive to partition
CKLIVE=`mount | grep "live" | grep -v "loop" | awk '{print $1}' | awk -F "/" '{print $3}' | sed -e 's/[0-9]//g'`
DRIVES=`cat /proc/partitions | grep -v "$CKLIVE" | grep -v loop | grep -v major | grep -v "^$" | awk '{print $4}' | grep -v "[0-9]"`

for i in $DRIVES; do
  partdrive="$i"
  partdrivesize=`grep -m 1 "$i" /proc/partitions | awk '{print $3}'`
  partdrivemenu="$partdrivemenu $partdrive $partdrivesize"
done


$DIALOG $TITLE"$TITLETEXT" $MENU $TEXT"Please select a drive to partition.\nIf the only option you see is to Quit the installer then no drives were found." $HEIGHT $WIDTH $MENUHEIGHT Exit "Quit the installer" $partdrivemenu 2>/tmp/choice.$$

if [ "$?" = "0" ]; then
PARTDRIVE=`cat /tmp/choice.$$`
else
PARTDRIVE="Exit"
fi
rm /tmp/choice.$$

if [ "$PARTDRIVE" = "Exit" ]; then
  $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Quitting the installer now." $HEIGHT $WIDTH
  exit 1
fi

$PARTITIONPROG /dev/$PARTDRIVE

#find the swap partition
TARGETSWAP=`fdisk -l | grep swap | awk '{print $1}' | cut -d "/" -f3`
#TARGETSWAP=`echo $TARGETSWAP | sed -r "s/\/dev\///g"`
for i in $TARGETSWAP; do
 swappart="$i"
 swappartsize=`grep -m 1 "$i" /proc/partitions | awk '{print $3}'`
 swappartmenu="$swappartmenu $swappart $swappartsize"
done

$DIALOG $TITLE"$TITLETEXT" $MENU $TEXT"Please select a swap partition to use.\nIf the only option you see is to Quit the installer then no swap partitions were found." $HEIGHT $WIDTH $MENUHEIGHT Exit "Quit the installer" $swappartmenu 2>/tmp/choice.$$

if [ "$?" = "0" ]; then
SWAP=`cat /tmp/choice.$$`
else
SWAP="Exit"
fi
rm /tmp/choice.$$

if [ "$SWAP" = "Exit" ]; then
  $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Quitting the installer now." $HEIGHT $WIDTH
  exit 1
fi


#choose the partition to install to
CKLIVE=`mount | grep "live" | grep -v "loop"  | awk '{print $1}' | awk -F "/" '{print $3}'`
PARTITIONS=`cat /proc/partitions | grep -v "$CKLIVE" | grep -v "loop" | grep -v "sr0" | awk '{print $4}' | grep "[0-9]"`
PARTINSTTEMP=`echo $PARTITIONS | sed -r "s/$SWAP//"`
PARTINST=`echo $PARTINSTTEMP`
for i in $PARTINST; do
tempsize=`grep -m 1 "$i" /proc/partitions | awk '{print $3}'`
if [ "$tempsize" = "1" ]; then
PARTINST=`echo $PARTINST | sed -r "s/$i//"`
fi
done



for i in $PARTINST; do
  part="$i"
  partsize=`grep -m 1 "$i" /proc/partitions | awk '{print $3}'`
  partmenu="$partmenu $part $partsize"
done


$DIALOG $TITLE"$TITLETEXT" $MENU $TEXT"Please select a partition to install the root system to.\nIf the only option you see is to Quit the installer then no partitions were found." $HEIGHT $WIDTH $MENUHEIGHT Exit "Quit the installer" $partmenu 2>/tmp/choice.$$

if [ "$?" = "0" ]; then
TARGETPART=`cat /tmp/choice.$$`
else
TARGETPART="Exit"
fi
rm /tmp/choice.$$

if [ "$TARGETPART" = "Exit" ]; then
  $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Quitting the installer now." $HEIGHT $WIDTH
  exit 1
fi

#choose filesystem type
$DIALOG $TITLE"$TITLETEXT" $MENU $TEXT"Please select filesystem type for the root partition" $HEIGHT $WIDTH $MENUHEIGHT ext2 "Ext2 filesystem" ext3 "Ext3 filesystem" ext4 "Ext4 filesystem" 2>/tmp/choice.$$

if [ "$?" = "0" ]; then
FSTYPE=`cat /tmp/choice.$$`
else
FSTYPE="ext3"
fi
rm /tmp/choice.$$


HOMEINST=`echo $PARTINST | sed -r "s/$TARGETPART//"`

for i in $HOMEINST; do
  homepart="$i"
  homepartsize=`grep -m 1 "$i" /proc/partitions | awk '{print $3}'`
  homepartmenu="$homepartmenu $homepart $homepartsize"
done

$DIALOG $TITLE"$TITLETEXT" $MENU $TEXT"Please select a partition to install /home to.\nIf the only option you see is root then no extra partitions were found." $HEIGHT $WIDTH $MENUHEIGHT root "put /home on the root partition" $homepartmenu 2>/tmp/choice.$$

if [ "$?" = "0" ]; then
HOMEPART=`cat /tmp/choice.$$`
else
HOMEPART="root"
fi
rm /tmp/choice.$$

if [ "$HOMEPART" != "root" ]; then
#choose filesystem type
$DIALOG $TITLE"$TITLETEXT" $MENU $TEXT"Please select filesystem type for the home partition" $HEIGHT $WIDTH $MENUHEIGHT noformat "Do Not Format the home partition - not recommended unless you know what you are doing" ext2 "Ext2 filesystem" ext3 "Ext3 filesystem" ext4 "Ext4 filesystem" 2>/tmp/choice.$$

if [ "$?" = "0" ]; then
HFSTYPE=`cat /tmp/choice.$$`
else
HFSTYPE="ext3"
fi
rm /tmp/choice.$$

fi



#check mode and get new user info if it is a dist mode
testmode=`grep "1000" /etc/passwd | grep -v "Live"`

if [ "$testmode" = "" ]; then

#root password entry section
TARGETROOTPASS="1"
TARGETROOTPASS2="2"

while [ "$TARGETROOTPASS" != "$TARGETROOTPASS2" ]; do

$DIALOG $TITLE"$TITLETEXT" $PASSWORD $TEXT"Please enter the password for root." $HEIGHT $WIDTH 2>/tmp/choice.$$
if [ "$?" = "0" ]; then
TARGETROOTPASS=`cat /tmp/choice.$$`
else
exit 1
fi
rm /tmp/choice.$$
$DIALOG $TITLE"$TITLETEXT" $PASSWORD $TEXT"Please enter the password for root again." $HEIGHT $WIDTH 2>/tmp/choice.$$
if [ "$?" = "0" ]; then
TARGETROOTPASS2=`cat /tmp/choice.$$`
else
exit 1
fi
rm /tmp/choice.$$

if [ "$TARGETROOTPASS" != "$TARGETROOTPASS2" ]; then
$DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Passwords do not match. Lets try again." $HEIGHT $WIDTH
fi

done

rm /tmp/choice.$$

#username input secton

$DIALOG $TITLE"$TITLETEXT" $ENTRY $TEXT"Please enter the new user's real name to be setup on the installed system." $HEIGHT $WIDTH 2>/tmp/choice.$$
if [ "$?" = "0" ]; then
TARGETUSERFULLNAME=`cat /tmp/choice.$$`
else
exit 1
fi
rm /tmp/choice.$$


$DIALOG $TITLE"$TITLETEXT" $ENTRY $TEXT"Please enter the new username to be setup on the installed system.\nMust be in lowercase letters only." $HEIGHT $WIDTH 2>/tmp/choice.$$
if [ "$?" = "0" ]; then
TARGETUSER=`cat /tmp/choice.$$`
else
exit 1
fi
rm /tmp/choice.$$


#make sure its all lowercase just in case
TARGETUSER="`echo $TARGETUSER | awk '{print tolower ($0)}'`"


#password entry section

TARGETPASS="1"
TARGETPASS2="2"

while [ "$TARGETPASS" != "$TARGETPASS2" ]; do

$DIALOG $TITLE"$TITLETEXT" $PASSWORD $TEXT"Please enter the password for $TARGETUSER." $HEIGHT $WIDTH 2>/tmp/choice.$$
if [ "$?" = "0" ]; then
TARGETPASS=`cat /tmp/choice.$$`
else
exit 1
fi
rm /tmp/choice.$$
$DIALOG $TITLE"$TITLETEXT" $PASSWORD $TEXT"Please enter the password for $TARGETUSER again." $HEIGHT $WIDTH 2>/tmp/choice.$$
if [ "$?" = "0" ]; then
TARGETPASS2=`cat /tmp/choice.$$`
else
exit 1
fi
rm /tmp/choice.$$

if [ "$TARGETPASS" != "$TARGETPASS2" ]; then
$DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Passwords do not match. Lets try again." $HEIGHT $WIDTH
fi

done

rm /tmp/choice.$$

fi


#hostname setup
$DIALOG $TITLE"$TITLETEXT" $ENTRY $TEXT"Please enter the hostname for the installed system." $HEIGHT $WIDTH 2>/tmp/choice.$$
if [ "$?" = "0" ]; then
TARGETHOSTNAME=`cat /tmp/choice.$$`
else
exit 1
fi
rm /tmp/choice.$$


#grub location
GrubSelectText () {

## Blank the array in case this function is being rerun
GrubMenu=()
CKLIVE=`mount | grep "live" | grep -v "loop" | awk '{print $1}' | awk -F "/" '{print $3}' | sed -e 's/[0-9]//g'`
Drives=$(cat /proc/partitions | grep -v "$CKLIVE" | grep -v loop | grep -v "Extended" | grep -v "extended" | grep -v "swap" | grep -v "Swap" | grep -v "Hidden" | grep -v major | grep -v "^$" | awk '{ print $4}')

for i in $Drives; do
PartDrive="$i"

if [ "$(echo "$PartDrive" | grep [0-9] )" = "" ]; then
 GrubMenu=("${GrubMenu[@]}" "$PartDrive" "Master boot record of disk")
fi
done

GrubMenu=( "${GrubMenu[@]}" "root" "Root partition - safe choice if you use a different boot manager" "rootmbr" "MBR of the root partition - this is what you want for a usb install" )

#grub location
$DIALOG $TITLE"$TITLETEXT" $MENU $TEXT"Please select where to install grub to.\n" $HEIGHT $WIDTH $MENUHEIGHT "${GrubMenu[@]}" 2>/tmp/choice.$$

if [ "$?" = "0" ]; then
GRUBLOCTEST=`cat /tmp/choice.$$`
fi
rm /tmp/choice.$$

if [ "$GRUBLOCTEST" = "root" ]; then
GRUBLOCTEXT="root partition of $TARGETPART"
GRUBLOC="/dev/$TARGETPART"
elif [ "$GRUBLOCTEST" = "rootmbr" ]; then
GRUBLOCTEXT="mbr of root partition of $TARGETPART"
GRUBLOC="/dev/$PARTDRIVE"
elif [ "$GRUBLOCTEST" = "" ]; then
GrubSelectText
exit 0
else
GRUBLOCTEXT="master boot record of $GRUBLOCTEST"
GRUBLOC="/dev/$GRUBLOCTEST"
fi

}

GrubSelectText

#dpkg-reconfigure tzdata
#Timezone setting

$DIALOG $TITLE"$TITLETEXT" $YESNO $TEXT"Is your system clock set to your current local time?\n\nAnswering no will indicate it is set to UTC" $HEIGHT $WIDTH
if [ $? = 0 ]; then
if [ "$(grep "UTC" /etc/adjtime)" != "" ]; then
 sed -i -e "s|UTC|LOCALTIME|g" /etc/adjtime
fi
else
if [ "$(grep "LOCALTIME" /etc/adjtime)" != "" ]; then
 sed -i -e "s|LOCALTIME|UTC|g" /etc/adjtime
fi
fi

cat /usr/share/zoneinfo/zone.tab | awk '{print $3}' | grep "/" | sort > /tmp/remastersys.zoneinfo
for i in `cat /tmp/remastersys.zoneinfo`; do
ZONES="$ZONES $i Timezone"
done
rm /tmp/remastersys.zoneinfo

$DIALOG $TITLE"$TITLETEXT" $MENU $TEXT"Please select a timezone for your system" $HEIGHT $WIDTH $MENUHEIGHT Exit "Quit the installer" $ZONES 2>/tmp/choice.$$

if [ "$?" = "0" ]; then
ZONESINFO=`cat /tmp/choice.$$`
else
ZONESINFO="Exit"
fi
rm /tmp/choice.$$

if [ "$ZONESINFO" = "Exit" ]; then
  $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Quitting the installer now." $HEIGHT $WIDTH
  exit 1
fi
echo "$ZONESINFO" > /etc/timezone
cp /usr/share/zoneinfo/$ZONESINFO /etc/localtime


#$SETLOCALE
#$SETCONSOLEDATA
#$SETXSERVER

if [ "$HOMEPART" != "root" ]; then
HOMETEXT=", $HOMEPART will be formatted $HFSTYPE for /home "
fi

if [ "$HFSTYPE" = "noformat" ]; then
HOMETEXT=", $HOMEPART will not be formatted but used for \n/home "
fi


if [ "$testmode" = "" ]; then
$DIALOG $TITLE"$TITLETEXT" $YESNO $TEXT"Please verify that this information is correct.\n\nNew user $TARGETUSER will be created on the $FSTYPE formatted $TARGETPART partition$HOMETEXT and grub will be installed to the $GRUBLOCTEXT.\n\nDo you want to continue?" $HEIGHT $WIDTH
if [ $? != 0 ]; then
exit 0
fi
else
$DIALOG $TITLE"$TITLETEXT" $YESNO $TEXT"Please verify that this information is correct.\nYour backup mode system will be installed on $FSTYPE formatted $TARGETPART partition$HOMETEXT and grub will be installed to the $GRUBLOCTEXT.\n\nDo you want to continue?" $HEIGHT $WIDTH
if [ $? != 0 ]; then
exit 0
fi
fi

#END TEXT MODE#########################################################################################################################################






else






#
#GUI MODE#########################################################################################################################################
#
#inform them what this is and ask if they want to continue

if [ "$testyad" = "" ]; then
xmessage "Yad not found.You can run cli mode by issuing 'sudo remastersys-installer' in a terminal window"
exit 1
fi

$DIALOG $TITLE"$TITLETEXT" $YESNO $TEXT"This is the live installer.  Do you want to continue?"

if [ $? != 0 ]; then
exit 0
fi

FRONTTEST=`cat /etc/X11/default-display-manager | grep kdm`

if [ "$FRONTTEST" = "" ]; then
FRONTEND="gnome"
else
FRONTEND="kde"
fi

$DIALOG $TITLE"$TITLETEXT" $YESNO $TEXT"The Live Installer will use the US English locale and keyboard layout by default.\n\nWould you like to install with different locale and keyboard settings?\n\nThe Installer itself will still use English."

if [ $? = 0 ]; then

dpkg-reconfigure -f $FRONTEND locales
dpkg-reconfigure -f $FRONTEND console-data
#dpkg-reconfigure -f $FRONTEND console-setup
dpkg-reconfigure -f $FRONTEND keyboard-configuration

fi

#fix for gparted being inhibited by udisks-daemon
killall -KILL udisks-daemon

$DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"We need to prepare a swap and install partition now.\n\n$PARTITIONPROG will allow you to create the new partitions.\n\nYou must create or have 1 install partition and 1 swap partition.\n\nIf you already have partitions setup then just quit $PARTITIONPROG and installation will continue.\n\nClick OK to continue."

#choose the drive to partition
CKLIVE=`mount | grep "live" | grep -v "loop" | awk '{print $1}' | awk -F "/" '{print $3}' | sed -e 's/[0-9]//g'`
DRIVES=`cat /proc/partitions | grep -v "$CKLIVE" | grep -v loop | grep -v major | grep -v "^$" | awk '{print $4}' | grep -v "[0-9]"`

for i in $DRIVES; do
  partdrive="$i"
  partdrivesize=`grep -m 1 "$i" /proc/partitions | awk '{print $3}'`
  partdrivemenu="$partdrivemenu $partdrive $partdrivesize"
done

PARTDRIVE=""
while [ "$PARTDRIVE" = "" ]
do
PARTDRIVE=`$DIALOGMENU $TITLE"$TITLETEXT" $MENU  $TEXT"Please select a drive to partition.\nIf the only option you see is to Quit the installer then no drives were found." Exit "Quit the installer" $partdrivemenu`
done

PARTDRIVE=`echo $PARTDRIVE | cut -d "|" -f 1`

if [ "$PARTDRIVE" = "Exit" ]; then
  $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Quitting the installer now."
  exit 1
fi

$PARTITIONPROG /dev/$PARTDRIVE

#find the swap partition
TARGETSWAP=`fdisk -l | grep swap | awk '{print $1}' | cut -d "/" -f3`
#TARGETSWAP=`echo $TARGETSWAP | sed -r "s/\/dev\///g"`
for i in $TARGETSWAP; do
 swappart="$i"
 swappartsize=`grep -m 1 "$i" /proc/partitions | awk '{print $3}'`
 swappartmenu="$swappartmenu $swappart $swappartsize"
done

SWAP=""
while [ "$SWAP" = "" ]
do
SWAP=`$DIALOGMENU $TITLE"$TITLETEXT" $MENU  $TEXT"Please select a swap partition to use.\nIf the only option you see is to Quit the installer then no swap partitions were found." Exit "Quit the installer" $swappartmenu`
done

SWAP=`echo $SWAP | cut -d "|" -f 1`

if [ "$SWAP" = "Exit" ]; then
  $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Quitting the installer now."
  exit 1
fi


#choose the partition to install to
CKLIVE=`mount | grep "live" | grep -v "loop" | awk '{print $1}' | awk -F "/" '{print $3}'`
PARTITIONS=`cat /proc/partitions | grep -v "$CKLIVE" | grep -v "loop" | grep -v "sr0" | awk '{print $4}' | grep "[0-9]"`
PARTINSTTEMP=`echo $PARTITIONS | sed -r "s/$SWAP//"`
PARTINST=`echo $PARTINSTTEMP`
for i in $PARTINST; do
tempsize=`grep -m 1 "$i" /proc/partitions | awk '{print $3}'`
if [ "$tempsize" = "1" ]; then
PARTINST=`echo $PARTINST | sed -r "s/$i//"`
fi
done


for i in $PARTINST; do
  part="$i"
  partsize=`grep -m 1 "$i" /proc/partitions | awk '{print $3}'`
  partmenu="$partmenu $part $partsize"
done

TARGETPART=""
while [ "$TARGETPART" = "" ]
do
TARGETPART=`$DIALOGMENU $TITLE"$TITLETEXT" $MENU  $TEXT"Please select a partition to install the root system to.\nIf the only option you see is to Quit the installer then no partitions were found." Exit "Quit the installer" $partmenu`
done

TARGETPART=`echo $TARGETPART | cut -d "|" -f 1`

if [ "$TARGETPART" = "Exit" ]; then
  $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Quitting the installer now."
  exit 1
fi
FSTYPE=""
while [ "$FSTYPE" = "" ]
do
FSTYPE=`$DIALOGMENU $TITLE"$TITLETEXT" $MENU  $TEXT"Please select filesystem type for the root partition" ext2 "Ext2 filesystem" ext3 "Ext3 filesystem" ext4 "Ext4 filesystem"`
done

FSTYPE=`echo $FSTYPE | cut -d "|" -f 1`


HOMEINST=`echo $PARTINST | sed -r "s/$TARGETPART//"`
for i in $HOMEINST; do
  homepart="$i"
  homepartsize=`grep -m 1 "$i" /proc/partitions | awk '{print $3}'`
  homepartmenu="$homepartmenu $homepart $homepartsize"
done

HOMEPART=""
while [ "$HOMEPART" = "" ]
do
HOMEPART=`$DIALOGMENU $TITLE"$TITLETEXT" $MENU  $TEXT"Please select a partition to install /home to.\nIf the only option you see is root then no extra partitions were found." root "put /home on the root partition" $homepartmenu`
done

HOMEPART=`echo $HOMEPART | cut -d "|" -f 1`

if [ "$HOMEPART" != "root" ]; then
HFSTYPE=""
while [ "$HFSTYPE" = "" ]
do
HFSTYPE=`$DIALOGMENU $TITLE"$TITLETEXT" $MENU  $TEXT"Please select filesystem type for the home partition" noformat "Do Not Format the home partition - not recommended unless you know what you are doing" ext2 "Ext2 filesystem" ext3 "Ext3 filesystem" ext4 "Ext4 filesystem"`
done
fi

HFSTYPE=`echo $HFSTYPE | cut -d "|" -f 1`

#check mode and get new user info if it is a dist mode
testmode=`grep "1000" /etc/passwd | grep -v "Live"`

if [ "$testmode" = "" ]; then

while [ "$PASSOK" != "Yes" ]; do

CHOICES=`$DIALOGMENU $TITLE"$TITLETEXT" --form \
--field="Password for root":H \
--field="Password for root again":H \
--field="New User Real Name" \
--field="New Username" \
--field="Password for new user":H \
--field="Password for new user again":H \
--field="Host Name for the computer"`

if [ "$?" = "0" ]; then
TARGETROOTPASS=`echo $CHOICES | cut -d "|" -f 1`
TARGETROOTPASS2=`echo $CHOICES | cut -d "|" -f 2`
TARGETUSERFULLNAME=`echo $CHOICES | cut -d "|" -f 3`
TARGETUSER=`echo $CHOICES | cut -d "|" -f 4`
TARGETPASS=`echo $CHOICES | cut -d "|" -f 5`
TARGETPASS2=`echo $CHOICES | cut -d "|" -f 6`
TARGETHOSTNAME=`echo $CHOICES | cut -d "|" -f 7`
else 
  $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Quitting the installer now."
  exit 1
fi

[ "$TARGETROOTPASS" != "" ] && \
[ "$TARGETROOTPASS" = "$TARGETROOTPASS2" ] && \
[ "$TARGETUSERFULLNAME" != "" ] && \
[ "$TARGETUSER" != "" ] && \
[ "$TARGETUSER" != "$LIVE_USERNAME" ] && \
[ "$TARGETPASS" != "" ] && \
[ "$TARGETPASS" = "$TARGETPASS2" ] && \
[ "$TARGETROOTPASS" != "$TARGETPASS" ] && \
[ "$TARGETHOSTNAME" != "" ] && \
PASSOK="Yes"

[ "$TARGETROOTPASS" = "" ] && $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Root password is blank."

[ "$TARGETROOTPASS" != "$TARGETROOTPASS2" ] && $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Root passwords do not match."

[ "$TARGETUSERFULLNAME" = "" ] && $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"User Full Name is blank."

[ "$TARGETUSER" = "" ] && $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Username is blank."

[ "$TARGETUSER" = "$LIVE_USERNAME" ] && $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Username can't be the same as the live username."

[ "$TARGETPASS" = "" ] && $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"User password is blank."

[ "$TARGETPASS" != "$TARGETPASS2" ] && $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"User passwords do not match."

[ "$TARGETROOTPASS" = "$TARGETPASS" ] && $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Root and user passwords are the same.\n\nPlease use different passwords."

[ "$TARGETHOSTNAME" = "" ] && $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Host Name is blank."


done


fi


#hostname setup
#TARGETHOSTNAME=`$DIALOG $TITLE"$TITLETEXT" $ENTRY $TEXT"Please enter the hostname for the installed system."`


#grub location

GrubSelectGUI () {

GrubMenu=()
CKLIVE=`mount | grep "live" | grep -v "loop" | awk '{print $1}' | awk -F "/" '{print $3}' | sed -e 's/[0-9]//g'`
Drives=$(cat /proc/partitions | grep -v "$CKLIVE" | grep -v loop | grep -v "Extended" | grep -v "extended" | grep -v "swap" | grep -v "Swap" | grep -v "Hidden" | grep -v major | grep -v "^$" | awk '{ print $4}')

for i in $Drives; do
PartDrive="$i"

if [ "$(echo "$PartDrive" | grep [0-9] )" = "" ]; then
 GrubMenu=("${GrubMenu[@]}" "$PartDrive" "Master boot record of disk")
fi
done

GrubMenu=( "${GrubMenu[@]}" "root" "Root partition - safe choice if you use a different boot manager" "rootmbr" "MBR of the root partition - this is what you want for a usb install" )

#grub location
GRUBLOCTEST=$($DIALOGMENU $TITLE"$TITLETEXT" $MENU $TEXT"Please select where to install grub to.\n" "${GrubMenu[@]}")

ret="$?"

if [ "$ret" = "252" ]; then
 GrubSelectGUI
 exit 0
elif [ "$GRUBLOCTEST" = "" ]; then
 GrubSelectGUI
 exit 0
fi

GRUBLOCTEST=$(echo "$GRUBLOCTEST" | awk -F '|' '{print $1}')

if [ "$GRUBLOCTEST" = "root" ]; then
GRUBLOCTEXT="root partition of $TARGETPART"
GRUBLOC="/dev/$TARGETPART"
elif [ "$GRUBLOCTEST" = "rootmbr" ]; then
GRUBLOCTEXT="mbr of root partition of $TARGETPART"
GRUBLOC="/dev/$PARTDRIVE"
else
GRUBLOCTEXT="master boot record of $GRUBLOCTEST"
GRUBLOC="/dev/$GRUBLOCTEST"
fi


}

GrubSelectGUI

#Timezone setting

$DIALOG $TITLE"$TITLETEXT" $YESNO $TEXT"Is your system clock set to your current local time?\n\nAnswering no will indicate it is set to UTC"
if [ $? = 0 ]; then
if [ "$(grep "UTC" /etc/adjtime)" != "" ]; then
 sed -i -e "s|UTC|LOCALTIME|g" /etc/adjtime
fi
else
if [ "$(grep "LOCALTIME" /etc/adjtime)" != "" ]; then
 sed -i -e "s|LOCALTIME|UTC|g" /etc/adjtime
fi
fi

cat /usr/share/zoneinfo/zone.tab | awk '{print $3}' | grep "/" | sort > /tmp/remastersys.zoneinfo
for i in `cat /tmp/remastersys.zoneinfo`; do
ZONES="$ZONES $i Timezone"
done
rm /tmp/remastersys.zoneinfo

ZONESINFO=""
while [ "$ZONESINFO" = "" ]
do
ZONESINFO=`$DIALOGMENU $TITLE"$TITLETEXT" $MENU  $TEXT"Please select a timezone for your system" Exit "Quit the installer" $ZONES`
done

ZONESINFO=`echo $ZONESINFO | cut -d "|" -f 1`

if [ "$ZONESINFO" = "Exit" ]; then
  $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Quitting the installer now."
  exit 1
fi


echo "$ZONESINFO" > /etc/timezone
cp /usr/share/zoneinfo/$ZONESINFO /etc/localtime

#xterm -e dpkg-reconfigure tzdata
#if [ "$1" = "intl" ]; then
#xterm -e $SETLOCALE
#xterm -e $SETCONSOLEDATA
#xterm -e $SETXSERVER
#fi

if [ "$HOMEPART" != "root" ]; then
HOMETEXT=", $HOMEPART will be formatted $HFSTYPE for /home "
fi

if [ "$HFSTYPE" = "noformat" ]; then
HOMETEXT=", $HOMEPART will not be formatted but used for \n/home "
fi

if [ "$testmode" = "" ]; then
$DIALOG $TITLE"$TITLETEXT" $YESNO $TEXT"Please verify that this information is correct.\n\nNew user $TARGETUSER will be created on the $FSTYPE formatted $TARGETPART partition$HOMETEXT and grub will be installed to the $GRUBLOCTEXT.\n\nDo you want to continue?"
if [ $? != 0 ]; then
  $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Quitting the installer now."
  exit 1

fi
else
$DIALOG $TITLE"$TITLETEXT" $YESNO $TEXT"Please verify that this information is correct.\n\nYour backup mode system will be installed on $FSTYPE formatted $TARGETPART partition$HOMETEXT and grub will be installed to the $GRUBLOCTEXT.\n\nDo you want to continue?"
if [ $? != 0 ]; then
  $DIALOG $TITLE"$TITLETEXT" $MSGBOX $TEXT"Quitting the installer now."
  exit 1

fi
fi


#END GUI MODE#########################################################################################################################################




fi





#
#
#
#install_to_hd section##########################################################################################################################
#
#
#


if [ "$GUI" != "" ]; then
progressbar "Setting up SWAP Now...Please Wait \n" &
fi

sleep 2
echo "Preparing swap partition now"
mkswap /dev/$SWAP
swapon /dev/$SWAP
if [ "$GUI" != "" ]; then
killall -KILL tail
fi
if [ "$GUI" != "" ]; then
progressbar "Formatting $TARGETPART Now...Please Wait \n" &
fi
echo "Formatting the $TARGETPART partition now"

## Preserve kernel options in the new grub system
NewGrubDefLine="$(cat /proc/cmdline | awk -F 'config ' '{print $2}' | awk -F ' BOOT' '{print $1}')"

OldGrubDefLine=$(grep -B 0  "GRUB_CMDLINE_LINUX_DEFAULT=" /etc/default/grub)
OldGrubLine=$(grep -B 0  "GRUB_CMDLINE_LINUX=" /etc/default/grub)
sed -i -e "s/$OldGrubDefLine/GRUB_CMDLINE_LINUX_DEFAULT=\"$NewGrubDefLine\"/g" /etc/default/grub
sed -i -e "s/$OldGrubLine/GRUB_CMDLINE_LINUX=\"\"/g" /etc/default/grub

#make the filesystem and mount the partition on /TARGET
if [ "`mount | grep $TARGETPART`" ]; then
echo "Unmounting the partition we are going to use and format now"
umount /dev/$TARGETPART
fi
mke2fs -t $FSTYPE /dev/$TARGETPART
mkdir -p /TARGET
sleep 2
echo "Mounting the TARGET partition now"
mount /dev/$TARGETPART /TARGET -o rw
sleep 2
echo "Using tune2fs to prevent the forced checks on boot"
tune2fs -c 0 -i 0 /dev/$TARGETPART 
rm -rf "/TARGET/lost+found"
if [ "$GUI" != "" ]; then
killall -KILL tail
fi
if [ "$HOMEPART" != "root" ]; then
if [ "$HFSTYPE" != "noformat" ]; then
if [ "$GUI" != "" ]; then
progressbar "Formatting $HOME Now...Please Wait \n" &
fi
echo "Formatting the $HOME partition now"
if [ "`mount | grep $HOMEPART`" ]; then
echo "Unmounting the partition we are going to use and format now"
umount /dev/$HOMEPART
fi
mke2fs -t $HFSTYPE /dev/$HOMEPART
fi
echo "Mounting the TARGET home partition now"
mkdir -p /TARGET/home
mount /dev/$HOMEPART /TARGET/home -o rw
tune2fs -c 0 -i 0 /dev/$HOMEPART
rm -rf "/TARGET/home/lost+found"
sleep 2
# Get fs type for home partition in case the user chose not to format
if [ "$HFSTYPE" = "noformat" ]; then
HFSTYPE=`mount | grep "/dev/$HOMEPART" | awk '{print $5}'`
fi
if [ "$GUI" != "" ]; then
killall -KILL tail
fi

fi

#get the cdrom device for fstab
#TARGETCDROM=`cat /proc/mounts | grep "/live/image" | awk '{print $1}'`
TARGETCDROM="/dev/cdrom"

sleep 1
if [ "$GUI" != "" ]; then
killall -KILL tail
fi

testmode=`grep "1000" /etc/passwd | grep -v "Live"`

if [ "$testmode" = "" ]; then
LIVEMODE="DIST"
else
LIVEMODE="BACKUP"
fi

cat > /var/log/remastersys-installer.log <<FOO
==============================
Remastersys-Installer log file
==============================
LIVEMODE=$LIVEMODE
==============================================================
GUI=$GUI
==============================================================
TARGETUSER=$TARGETUSER
==============================================================
TARGETHOSTNAME=$TARGETHOSTNAME
==============================================================
SWAP=$SWAP
==============================================================
TARGETPART=$TARGETPART
==============================================================
FSTYPE=$FSTYPE
==============================================================
HOMEPART=$HOMEPART
==============================================================
HFSTYPE=$HFSTYPE
==============================================================
GRUBLOC=$GRUBLOC
==============================================================
FOO

echo "==============================================================" >> /var/log/remastersys-installer.log
echo "MOUNTS" >> /var/log/remastersys-installer.log
echo "==============================================================" >> /var/log/remastersys-installer.log
mount >> /var/log/remastersys-installer.log
echo "==============================================================" >> /var/log/remastersys-installer.log
echo "FDISK listing" >> /var/log/remastersys-installer.log
echo "==============================================================" >> /var/log/remastersys-installer.log
fdisk -l >> /var/log/remastersys-installer.log
echo "==============================================================" >> /var/log/remastersys-installer.log
echo "live config listing" >> /var/log/remastersys-installer.log
echo "==============================================================" >> /var/log/remastersys-installer.log
cat /etc/live/config.conf >> /var/log/remastersys-installer.log
echo "==============================================================" >> /var/log/remastersys-installer.log
echo "End of Log" >> /var/log/remastersys-installer.log
echo "==============================================================" >> /var/log/remastersys-installer.log



if [ "$GUI" != "" ]; then
progressbar "Copying the files to the TARGET System...Please Wait \n" &
fi


# copy the live system to the hd
echo "Copying the live system to the hard drive now."
echo "This may take a while so please wait until completed."


            
if [ "$HFSTYPE" = "noformat" ]; then
rsync -a / /TARGET --ignore-existing --exclude=/{TARGET,home,live,cdrom,mnt,proc,run,sys,media}
else
rsync -a / /TARGET --ignore-existing --exclude=/{TARGET,live,cdrom,mnt,proc,run,sys,media}
fi

mkdir -p /TARGET/{proc,mnt,run,sys,media/cdrom}

#remove the live installer from the desktop of /etc/skel/Desktop
if [ -f /TARGET/etc/skel/Desktop/remastersys-installer.desktop -o -f /TARGET/etc/skel/Desktop/remastersys-installer-ked.desktop ]; then
rm -f /TARGET/etc/skel/Desktop/remastersys-installer*.desktop
fi

echo "Completed copying the files."
if [ "$GUI" != "" ]; then
killall -KILL tail
fi
if [ "$GUI" != "" ]; then
progressbar "Performing post-install steps now...Please Wait\n" &
fi
echo "Performing post-install steps now"

#prepare the chroot environment for some post install changes
mount -o bind /proc /TARGET/proc
mount -o bind /dev /TARGET/dev
mount -o bind /sys /TARGET/sys
rm -f /TARGET/etc/fstab
rm -f /TARGET/etc/profile.d/zz-live.sh

#create the new fstab
if [ "$HOMEPART" = "root" ]; then
cat > /TARGET/etc/fstab <<FOO
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>

proc /proc proc defaults 0 0
# /dev/$TARGETPART
/dev/$TARGETPART / $FSTYPE relatime,errors=remount-ro 0 1
# /dev/$SWAP
/dev/$SWAP none swap sw 0 0
# cdrom
$TARGETCDROM /media/cdrom udf,iso9660 user,noauto,exec,utf8 0 0

FOO

else

cat > /TARGET/etc/fstab <<FOO
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>

proc /proc proc defaults 0 0
# /dev/$TARGETPART
/dev/$TARGETPART / $FSTYPE relatime,errors=remount-ro 0 1
# /dev/$HOMEPART home
/dev/$HOMEPART /home $HFSTYPE relatime 0 0
# /dev/$SWAP
/dev/$SWAP none swap sw 0 0
# cdrom
$TARGETCDROM /media/cdrom udf,iso9660 user,noauto,exec,utf8 0 0

FOO

fi


# remove diverted update-initramfs as live-initramfs makes it a dummy file when booting the livecd
if [ -f /TARGET/usr/sbin/update-initramfs.debian ]; then
rm -f /TARGET/usr/sbin/update-initramfs
fi

# remove diverted update-notifier as it is disabled by live-config
if [ -f /TARGET/usr/lib/update-notifier/apt-check.debian ]; then
rm -f /TARGET/usr/lib/update-notifier/apt-check
fi

# remove diverted anacron as it is disabled by live-config
if [ -f /TARGET/usr/sbin/anacron.debian ]; then
rm -f /TARGET/usr/sbin/anacron
fi

# fix adept_notifier by copying the file we saved when remastersys first ran as live-initramfs removes it
if [ -f /TARGET/etc/remastersys/adept_notifier_auto.desktop ]; then
mv /TARGET/etc/remastersys/adept_notifier_auto.desktop /TARGET/usr/share/autostart/adept_notifier_auto.desktop
fi

# copy trackerd stuff as live-initramfs disables it
if [ -f /TARGET/etc/remastersys/tracker-applet.desktop ]; then
mv /TARGET/etc/remastersys/tracker-applet.desktop /TARGET/etc/xdg/autostart/tracker-applet.desktop
fi
if [ -f /TARGET/etc/remastersys/trackerd.desktop.xdg ]; then
mv /TARGET/etc/remastersys/trackerd.desktop.xdg /TARGET/etc/xdg/autostart/trackerd.desktop
fi
if [ -f /TARGET/etc/remastersys/trackerd.desktop.share ]; then
mv /TARGET/etc/remastersys/trackerd.desktop.share /TARGET/usr/share/autostart/trackerd.desktop
fi

#restore original inittab as live-initramfs changes it
cp /TARGET/usr/share/sysvinit/inittab /TARGET/etc/inittab

#check if this is a backup livecd or a dist livecd
if [ "$TARGETUSER" != "" ]; then

echo "$TARGETHOSTNAME" > /TARGET/etc/hostname
echo "127.0.0.1 localhost" > /TARGET/etc/hosts
echo "127.0.0.1 $TARGETHOSTNAME" >> /TARGET/etc/hosts
touch /TARGET/etc/resolv.conf

#remove autologin from livecd on installed system

#gdm and gdm3 section
if [ -f /TARGET/etc/gdm/gdm.conf ]; then
sed -i -e 's/AutomaticLogin/#AutomaticLogin/g' /TARGET/etc/gdm/gdm.conf
sed -i -e 's/TimedLogin/#TimedLogin/g' /TARGET/etc/gdm/gdm.conf
fi
if [ -f /TARGET/etc/gdm3/daemon.conf ]; then
sed -i -e 's/AutomaticLogin/#AutomaticLogin/g' /TARGET/etc/gdm3/daemon.conf
sed -i -e 's/TimedLogin/#TimedLogin/g' /TARGET/etc/gdm3/daemon.conf
fi

#kde3 and kde4 section
if [ -f /TARGET/etc/default/kdm.d/live-autologin ]; then
rm -f /TARGET/etc/default/kdm.d/live-autologin
fi
if [ -f /TARGET/etc/kde3/kdm/kdmrc ]; then
sed -i -e 's/AutoLogin/#AutoLogin/g' /TARGET/etc/kde3/kdm/kdmrc
sed -i -e 's/AutoReLogin/#AutoReLogin/g' /TARGET/etc/kde3/kdm/kdmrc
fi
if [ -f /TARGET/etc/kde4/kdm/kdmrc ]; then
sed -i -e 's/AutoLogin/#AutoLogin/g' /TARGET/etc/kde4/kdm/kdmrc
sed -i -e 's/AutoReLogin/#AutoReLogin/g' /TARGET/etc/kde4/kdm/kdmrc
fi

#slim section
if [ -f /TARGET/etc/slim.conf ]; then
sed -i -e 's/auto_login/#auto_login/g' /TARGET/etc/slim.conf
sed -i -e 's/default_user/#default_user/g' /TARGET/etc/slim.conf
fi

#lxdm section
if [ -f /TARGET/etc/lxdm/lxdm.conf ]; then
sed -i -e 's/autologin/#autologin/g' /TARGET/etc/lxdm/lxdm.conf
sed -i -e 's/session/#session/g' /TARGET/etc/lxdm/lxdm.conf
fi

#lightdm section
if [ -f /TARGET/etc/lightdm/lightdm.conf ]; then
sed -i -e 's/autologin/#autologin/g' /TARGET/etc/lightdm/lightdm.conf
fi

#cleanup live polkit file from new install
rm -f /TARGET/var/lib/polkit-1/localauthority/10-vendor.d/10-live-cd.pkla

if [ -f /etc/remastersys/remastersys-installer.conf ]; then
. /etc/remastersys/remastersys-installer.conf
fi
if [ "$DEFAULTGROUPS" = "" ]; then
DEFAULTGROUPS="audio,cdrom,dialout,floppy,video,plugdev,netdev"
fi

cat > /TARGET/bin/tempinstallerscript <<FOO
#!/bin/bash

echo -e "$TARGETROOTPASS\n$TARGETROOTPASS\n" | passwd root
userdel -f -r $LIVE_USERNAME
sed -i '/$LIVE_USERNAME/d' /etc/sudoers
groupadd -g 1000 $TARGETUSER
useradd -u 1000 -g 1000 -c "$TARGETUSERFULLNAME,,," -G $DEFAULTGROUPS -s /bin/bash -m $TARGETUSER
echo -e "$TARGETPASS\n$TARGETPASS\n" | passwd $TARGETUSER
dpkg-divert --remove --rename --quiet /usr/lib/update-notifier/apt-check
dpkg-divert --remove --rename --quiet /usr/sbin/update-initramfs
dpkg-divert --remove --rename --quiet /usr/sbin/anacron
update-initramfs -t -c -k $(/bin/uname -r)
shadowconfig on

FOO


else

#echo "$TARGETHOSTNAME" > /TARGET/etc/hostname
#echo "127.0.0.1 localhost" > /TARGET/etc/hosts
#echo "127.0.0.1 $TARGETHOSTNAME" >> /TARGET/etc/hosts
#touch /TARGET/etc/resolv.conf


cat > /TARGET/bin/tempinstallerscript <<FOO
#!/bin/bash

dpkg-divert --remove --rename --quiet /usr/lib/update-notifier/apt-check
dpkg-divert --remove --rename --quiet /usr/sbin/update-initramfs
dpkg-divert --remove --rename --quiet /usr/sbin/anacron
update-initramfs -t -c -k $(uname -r)
for i in `ls -d /home/*`; do

if [ /$i/.config/Thunar/volmanrc ]; then
  sed -i -e 's/FALSE/TRUE/g' /$i/.config/Thunar/volmanrc
  cp -f /$i/.config/volmanrc /root/.config/Thunar/volmanrc
fi

done

FOO


fi

chmod 755 /TARGET/bin/tempinstallerscript
chroot /TARGET /bin/tempinstallerscript
rm /TARGET/bin/tempinstallerscript
if [ "$GUI" != "" ]; then
killall -KILL tail
fi
# Setup grub

cat > /tmp/Remastersys-Grub-Install << FOO
#!/bin/bash
chroot /TARGET grub-install --force --no-floppy "$GRUBLOC"
chroot /TARGET update-grub
exit 0
FOO

chmod +x /tmp/Remastersys-Grub-Install

if [ "$GUI" != "" ]; then
progressbar "Installing and setting up grub...Please Wait\n" &
xterm -e /tmp/Remastersys-Grub-Install
sleep 1
rm -rf /tmp/Remastersys-Grub-Install
else
echo "Installing and setting up grub."
/tmp/Remastersys-Grub-Install
sleep 1
rm -rf /tmp/Remastersys-Grub-Install
fi

echo "Post-install has completed."
echo
echo "Unmounting the TARGET partition."
sleep 1
umount /TARGET/proc
sleep 1
umount /TARGET/dev
sleep 1
umount /TARGET/sys
sleep 1
umount /TARGET/home
sleep 1
umount /TARGET
sleep 1

if [ "$GUI" != "" ]; then
killall -KILL tail
fi


$DIALOG $TITLE"$TITLETEXT" $YESNO $TEXT"Installation is complete.\n\nIf everything went well you should have your new system installed and ready.\n\nDo you want to reboot now to try it out?" $HEIGHT $WIDTH

if [ $? != 0 ]; then
exit 0
else
reboot
fi


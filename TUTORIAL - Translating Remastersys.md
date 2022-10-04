# TUTORIAL
# Translating Remastersys

*In this tutorial you will learn how to translate Remastersys into your language.*

## Tools of trade

Translators will need the following tools:

* __msgmerge__ - merge message catalog and template (I believe it is part of the gettext package)
* __poedit__ - a gettext catalog editor
* __remastersys' source code__ - download by clicking [here](https://github.com/nerun/remastersys/archive/refs/heads/main.zip).
* __unzip__ - unarchiver for .zip files

Install:

```shell
sudo aptitude install gettext poedit unzip
```

## Files

The files you will need to use to start a translation have the extension POT, and are located in these directories:

* remastersys/usr/share/locale/pt\_BR/LC\_MESSAGES
   * remastersys-grubconfig.pot
   * remastersys-installer.pot
   * remastersys.pot
   * remastersys-skelcopy.pot
* remastersys-gui/usr/share/locale/pt\_BR/LC\_MESSAGES
   * remastersys-grub-restore.pot
   * remastersys-gui.pot
   * remastersys-bootable-usb.pot
   
## Creating your workspace

Unzip the source code:

```shell
unzip remastersys-main.zip
```

Let's find the POT files and bring them all to the current folder:

```shell
find ./remastersys-main -type f -name "*.pot" -exec cp '{}' . \;
```

You can delete the folder and zip now:

```shell
rm -r remastersys-main/ remastersys-main.zip
```

Find out what the posix code is for your language in case you don't know:

```shell
locale -a | tail -1 | cut -d'.' -f1
```

Provide this code to the developers when submitting your translation.

## Poedit

Open all the POT files one by one with poedit. Below, click on the "Create New Translation" button, select your language and save the new file, which will have the POT extension (goodbye "T").

Now open each of the PO files in poedit. The left column displays the original English text, click on a line and translate everything.

Preserve any extraneous signals if there are. Remember that "\n" is a line break and that your language can produce longer or shorter sentences than the English language. Multiple spaces are also intentional.

When you're done, click "Validate" to make sure you've translated everything.

Now just send these translated files to the developers. If you know what a Pull Request (PR) is, feel free to submit one if you like.

## Updating your translation

The texts change quite often, more than we would like, but as the software stabilizes, the texts also tend to remain unchanged for longer.

To update your translation, repeat the process above but instead of starting the translation all over again, just update your PO files with the changes from the POT files using the command:

```shell
msgmerge -U file.po file.pot
```

Alternatively you can use this shell script to update all PO files with POT as long as they are all in the same folder. Remember to make it executable (chmod +x filename):

```shell
#!/bin/bash
for i in $(ls .)
do
    if [ "${i: -3}" = ".po" ]
    then
        msgmerge -U $i $i"t"
    fi
done
```

Or, in a single line direct in terminal:

```shell
for i in $(ls .); do; if [ "${i: -3}" = ".po" ]; then; msgmerge -U $i $i"t"; fi; done
```

Delete the POT files and open the PO files translating what was changed or inserted.

EOF
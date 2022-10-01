# DEVELOPER NOTES

### KNOWN BUGS

* There may be many bugs that I am unaware of...

### THINGS TO DO

* Needed tests:
   * remastersys-skelcopy: need to know if the user's personal settings are actually being used.
* manpages:
   * add remastersys-grubconfig, -installer and -skelcopy
   * create manpages to remastersys-gui, -grub-restore and -bootable-usb
* help text:
   * unify all the --help text and/or create aliases like:
      * `remastersys -b` ➟ `remastersys-grubconfig` (b = bootloader)
      * `remastersys -i` ➟ `remastersys-installer`
      * `remastersys -s` ➟ `remastersys-skelcopy`
      * `remastersys -g` ➟ `remastersys-gui`
      * `remastersys -gu` ➟ `remastersys-bootable-usb`
      * `remastersys -gb` ➟ `remastersys-grub-restore`
* Issues:
   * [Add EFI / UEFI boot support](https://github.com/nerun/remastersys/issues/3)
   * [Remove 4 GB ISO limitation](https://github.com/nerun/remastersys/issues/2)
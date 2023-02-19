# DEVELOPER NOTES

## THINGS TO DO

* ~~copyright:~~
   * ~~version 4 has been released in `Sep 23, 2022`. I should update copyright to 2022 probably.~~
* ~~move from genisoimage/mkisofs to xorriso?~~
* deal with:
   * /etc/remastersys/grub.png
   * /etc/remastersys/grub-default.png
   * /etc/remastersys/isolinux/splash.png
   * /etc/remastersys/isolinux/splash-default.png
   * should verify remastersys-gui too, since it's use splash/grub.png
* remastersys-gui:
   * add **_libremastersysgui.sh_** to **_remastersys-installer_**, OR split GUI MODE from within **_remastersys-installer_** script.
   * create unified help: but should i move "grub -\-restore" to remastersys-gui unified help? Probably yes.
   * create manpages: remastersys-gui, -grub-restore and -bootable-usb.
* [Issue #3](https://github.com/nerun/remastersys/issues/3): Add EFI / UEFI boot support.
* ~~[Issue #8](https://github.com/nerun/remastersys/issues/8): ISO images larger than 4 GiB. I should try `-iso-level 3`.~~
* need to test:
   * remastersys-skelcopy: need to know if the user's personal settings are actually being used.
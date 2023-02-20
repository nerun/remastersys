# DEVELOPER NOTES

* [Issue #3](https://github.com/nerun/remastersys/issues/3): Add EFI / UEFI boot support.
* **fail safe** is not working in both _isolinux/grub_ boot modes and in both _backup/dist_ modes.
* remastersys-gui:
   * add **_libremastersysgui.sh_** to **_remastersys-installer_**, OR split GUI MODE from within **_remastersys-installer_** script.
   * create unified help: but should i move "grub -\-restore" to remastersys-gui unified help? Probably yes.
   * create manpages: remastersys-gui, -grub-restore and -bootable-usb.

# REMASTERSYS

<a href="https://github.com/nerun/remastersys/blob/master/LICENSE" target="_blank"><img alt="License: GPLv2" src="https://img.shields.io/badge/License-GPLv2-blue" /></a> <a href="https://www.debian.org/" target="_blank"><img alt="System: Debian 11" src="https://img.shields.io/badge/System-Debian%2011-blue" /></a> <a href="https://github.com/nerun/remastersys/releases" target="_blank"><img alt="Version: 4.0.0 alpha" src="https://img.shields.io/badge/Version-4.0.0%20alpha-orange" /></a>

**Remastersys** is a tool that can be used to do two things with an existing Linux Debian installation:

* A full system backup, including personal data, to a Live CD/DVD that you can use anywhere and install.
* A distributable copy you can share with friends. This will not have any of your personal user data in it.

This is a fork of the famous [Remastersys (ver. 3.0.0-1)](https://web.archive.org/web/20130423105647/http://www.remastersys.com/), developed by Tony "Fragadelic" Brijeski and discontinued in April, 2013.

Just burn your Distro or Backup image onto a CD/DVD media or a USB stick (with programs like [Balena Etcher](https://www.balena.io/etcher/)), then insert the media/pendrive into the PC and reboot.

## Current state

The program is still **under development, with many bugs**. However, it is already possible to see many new features compared to the original **remastersys**:

* Internationalization (scripts, menu entries and desktop files): default language is English, but it is possible to create locales for other languages, such as pt_BR, which is already available.
* All scripts have been revised, improving source code formatting and several minor performance improvements.
* Updated Isolinux (4.02 > 6.04) and Memtest86 (4.00 > 4.3.7).
* Updated makesquashfs' compression method from gzip to zstd: generates systems 8% smaller in half the time.
* Improved terminal messages, with removal of many small errors and visual improvements. Many improvements are being made to the GUI as well.
* Updated icons and images.
* Improved man pages.
* Removed plymouth. I don't know what it's for, I can reinsert it in the future.
* Removed gksu/gksudo support, using sudo by default.
* Updated dependencies:
  * live-config-systemd: included to work with systemd.
  * syslinux-utils: included to fix bug using isohybrid.
  * zstd: included because of new makesquashfs??? compression method.
  * memtest86+: removed since it is not used by system, isolinux has its own binary.
  * xresprobe: removed since is no longer used.

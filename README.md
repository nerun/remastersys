# REMASTERSYS

<a href="https://github.com/nerun/remastersys/blob/master/LICENSE" target="_blank"><img alt="License: GPLv2" src="https://img.shields.io/badge/License-GPLv2-blue" /></a> <a href="https://www.debian.org/" target="_blank"><img alt="System: Debian 11" src="https://img.shields.io/badge/System-Debian%2011-blue" /></a> <a href="https://github.com/nerun/remastersys/releases" target="_blank"><img alt="Version: 4.0 alpha 12" src="https://img.shields.io/badge/Version-4.0%20alpha%2012-red" /></a>

**Remastersys** is a tool that can be used to do two things with an existing Linux Debian installation:

* A full system backup, including personal data, to a Live CD/DVD that you can use anywhere and install.
* A distributable copy you can share with friends. This will not have any of your personal user data in it.

This is a fork of the famous [Remastersys (ver. 3.0.0-1)](https://web.archive.org/web/20130423105647/http://www.remastersys.com/), developed by Tony "Fragadelic" Brijeski and discontinued in April, 2013.

Just burn your Distro or Backup image onto a CD/DVD media or a USB stick (with programs like [Balena Etcher](https://www.balena.io/etcher/)), then insert the media/pendrive into the PC and reboot.

## Changelog

The program is still **under development, with many bugs**. However, it is already possible to see many new features compared to the original **remastersys**:

* Full internationalization (scripts, menu entries and desktop files). Easy to create locales for other languages with Poedit. Defaults to English, but Brazilian Portuguese is also available.
* All scripts have been revised, improving source code formatting and several minor performance improvements.
* Improved terminal messages, fixed many small errors and added a few visual improvements. Many improvements are being made to the GUI as well.
* Updated versions of Isolinux (4.02 > 6.04) and Memtest86 (4.00 > 4.3.7). Also added Memtest86+ v6.00-beta3 to Live CD.
* Changed makesquashfs' compression method from gzip to zstd. Zstd generates images up to 10% smaller in almost half the time.
* Updated icons and images.
* Improved man pages.
* Removed plymouth, but can be reinserted it in the future.
* Changed gksu/gksudo to sudo.
* Updated dependencies:
  * live-config-systemd (included because of systemd).
  * syslinux-utils (included to fix bug when using isohybrid).
  * zstd (included because of makesquashfs’ new compression method).
  * memtest86+ (excluded since it is not used by system, isolinux has its own binary).
  * xresprobe (excluded since is no longer used).

## Current state

This program has 2 packages: **remastersys** (program itself, terminal only) and **remastersys-gui** (graphical interface). In this ALPHA stage, just remastersys seems to work very well. The GUI package still need some work, mainly internationalization, but it's working (in pt_BR).

## Basic usage
* Create debian packages: `./package-creator`, write version number "4.0a", hit ENTER, then write a short changelog. You can write just "f" in changelog and hit ENTER.
* Install both packages: `sudo dpkg -i *.deb`
* Fix dependencies if you need: `sudo apt-get update --fix-missing` and `sudo apt-get install -f`
* Read instructions:
  * `man remastersys`
  * `remastersys --help`
  * `remastersys-grubconfig --help`
  * `remastersys-installer --help`
  * `remastersys-skelcopy --help`
# REMASTERSYS

<a href="https://github.com/nerun/remastersys/blob/master/LICENSE" target="_blank"><img alt="License: GPLv2" src="https://img.shields.io/badge/License-GPLv2-blue" /></a> <a href="https://www.debian.org/" target="_blank"><img alt="System: Debian 11" src="https://img.shields.io/badge/System-Debian%2011-blue" /></a> <a href="https://github.com/nerun/remastersys/releases" target="_blank"><img alt="Version: 4.8" src="https://img.shields.io/badge/Version-4.8%20beta-brightgreen" /></a>

**Remastersys** is a tool that can be used to do two things with an existing Linux Debian installation:

* A full system backup, including personal data, to a Live ISO that you can use anywhere and install.
* A distributable copy you can share with friends. This will not have any of your personal user data in it.

Just burn your Distro or Backup image onto a CD/DVD media or USB stick (using Remastersys Bootable USB), then insert the media/pendrive into the PC and reboot.

*This is a fork of the famous [Remastersys (ver. 3.0.0-1)](https://web.archive.org/web/20130423105647/http://www.remastersys.com/), developed by Tony "Fragadelic" Brijeski and discontinued in April, 2013.*

## Changelog

There are still a few bugs, but there are also many new features compared to the original **remastersys**:

* Full internationalization (scripts, menu entries and desktop files). Easy to create locales for other languages with Poedit. Defaults to English, but Brazilian Portuguese is also available.
* All scripts have been revised, adding several improvements to source code, including more readable formatting, increased performance, various bug fixes, visual improvements of terminal messages and code optimization.
* Updated versions of Isolinux (4.02 > 6.04) and Memtest86 (4.00 > 4.3.7). Also added Memtest86+ v6.00-beta3 to Live CD.
* Changed makesquashfs' compression method from gzip to zstd. Zstd generates images up to 10% smaller in almost half the time.
* Dependencies included: live-config-systemd, syslinux-utils, sudo, zstd.
* Dependencies excluded: memtest86+, mkisofs and xresprobe.
* Removed plymouth, but can be reinserted it in the future.
* Changed gksu/gksudo to ysudo (new tool).
* Updated icons and images.
* Improved man pages.

## Current state

This program has 2 packages: **remastersys** (program itself, terminal mode) and **remastersys-gui** (graphical interface). Main features seems to work, but there are some bugs.

## Basic usage
* If there are no Debian packages to download and install in [releases](https://github.com/nerun/remastersys/releases) section, you should create debian packages:
  * run: `./package-creator`
  * write version number or accept suggested version by hitting ENTER
  * update changelogs if you wish (in "nano"), answering (y/n) and hit ENTER
* Install both packages: `sudo apt install ./remastersys*.deb`
* Read instructions:
  * `man remastersys`
  * `sudo remastersys --help`
* If you have installed the GUI package, you should be capable to search for these shortcuts in the menu:
  * Remastersys Bootable USB
  * Remastersys Creator
  * Remastersys GRUB Restorer
  * Remastersys Installer

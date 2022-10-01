# REMASTERSYS

<a href="https://github.com/nerun/remastersys/blob/master/LICENSE" target="_blank"><img alt="License: GPLv2" src="https://img.shields.io/badge/License-GPLv2-blue" /></a> <a href="https://www.debian.org/" target="_blank"><img alt="System: Debian 11" src="https://img.shields.io/badge/System-Debian%2011-blue" /></a> <a href="https://github.com/nerun/remastersys/releases" target="_blank"><img alt="Version: 4.3" src="https://img.shields.io/badge/Version-4.3-brightgreen" /></a>

**Remastersys** is a tool that can be used to do two things with an existing Linux Debian installation:

* A full system backup, including personal data, to a Live CD/DVD that you can use anywhere and install.
* A distributable copy you can share with friends. This will not have any of your personal user data in it.

Just burn your Distro or Backup image onto a CD/DVD media or a USB stick (with programs like [Balena Etcher](https://www.balena.io/etcher/)), then insert the media/pendrive into the PC and reboot.

*This is a fork of the famous [Remastersys (ver. 3.0.0-1)](https://web.archive.org/web/20130423105647/http://www.remastersys.com/), developed by Tony "Fragadelic" Brijeski and discontinued in April, 2013.*

## Changelog

There are still a few bugs, but there are also many new features compared to the original **remastersys**:

* Full internationalization (scripts, menu entries and desktop files). Easy to create locales for other languages with Poedit. Defaults to English, but Brazilian Portuguese is also available.
* All scripts have been revised, adding several improvements to source code, including more readable formatting, increased performance, various bug fixes, visual improvements of terminal messages and code optimization.
* Updated versions of Isolinux (4.02 > 6.04) and Memtest86 (4.00 > 4.3.7). Also added Memtest86+ v6.00-beta3 to Live CD.
* Changed makesquashfs' compression method from gzip to zstd. Zstd generates images up to 10% smaller in almost half the time.
* Updated icons and images.
* Improved man pages.
* Removed plymouth, but can be reinserted it in the future.
* Changed gksu/gksudo to sudo.
* Dependencies included: live-config-systemd, syslinux-utils, sudo, zstd.
* Dependencies excluded: memtest86+ and xresprobe.

## Current state

This program has 2 packages: **remastersys** (program itself, terminal mode) and **remastersys-gui** (graphical interface). Main features seems to work very well.

## Basic usage
* If there are no packaged to download and install, you should create debian packages: `./package-creator`, write version number, hit ENTER, write a short changelog, write "end" and hit ENTER again.
* Install both packages: `sudo dpkg -i *.deb`
* Fix dependencies if you need: `sudo apt-get install -f`
* Read instructions:
  * `man remastersys`
  * `remastersys --help`
  * `remastersys-grubconfig --help`
  * `remastersys-installer --help`
  * `remastersys-skelcopy --help`
* If you have installed the GUI, you should be capable to search for these shortcuts (desktop icons):
  * Remastersys GRUB Restorer
  * Remastersys Creator
  * Remastersys Installer
  * Remastersys Bootable USB

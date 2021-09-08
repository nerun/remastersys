# Welcome to Remastersys

<a href="https://github.com/nerun/remastersys/blob/master/LICENSE" target="_blank"><img alt="License: GPLv2" src="https://img.shields.io/badge/License-GPLv2-blue" /></a> <a href="https://www.debian.org/" target="_blank"><img alt="System: Debian 6 (Squeeze)" src="https://img.shields.io/badge/System-Debian%206%20(Squeeze)-blue" /></a> <a href="https://github.com/nerun/remastersys/releases" target="_blank"><img alt="Version: 3.0.0-1" src="https://img.shields.io/badge/Version-3.0.0--1-orange" /></a>

**A Unique Linux Backup to Live Media Tool for Debian and Ubuntu**

*Contrary to some rumours floating around the internet, Remastersys is alive and well*

## What is remastersys?

Remastersys is a tool that can be used to do 2 things with an existing Debian, Ubuntu or derivative installation.

1. It can make a full system backup including personal data to a live cd or dvd that you can use anywhere and install.
2. It can make a distributable copy you can share with friends. This will not have any of your personal user data in it.

The resulting iso file can be used on any other PC that still meets the original minimum requirements of Ubuntu or Debian. Things like the graphics card and other hardware will be configured and setup automatically and you do not have to use identical hardware. Ubuntu's live boot tool, casper, currently blacklists Nvidia and AMD proprietary drivers so they will not be available on the live system and will need to be reinstalled after installation of your custom system.

Currently there is a size limitation imposed by the genisomage tool in Ubuntu and Debian. This tool is used to create the iso file. This limits the maximum single file size for the iso to be set at 4GB which means the entire compressed filesystem.squashfs file (your complete compressed system) must fall under this size. If it does not then the iso file will not be created. It is recommended to remove most media files and any virtual machine hard drives like the ones used by qemu, Virtual Box, etc off the system while you run the backup mode or make sure you add these files to the excludes in the /etc/remastersys.conf file either manually or through the gui. Due to the size restriction it is best to think of Remastersys Backup as a tool to backup your applications and your personal config files while leaving your media files, etc out of it as they can be easily backed up to a dvd or external portable drive and copied back afterwards.

I personally use remastersys to make numerous backups of the computers I have at home running Ubuntu and Debian and also use it to create custom installs for the different needs of the PC's in my home.

# About this repository

All of the above text (except for the GitHub badges) is an extract from the [www.remastersys.com](https://web.archive.org/web/20130423105647/http://www.remastersys.com/) website as it was on April 23, 2013. The website no longer exists and the provided link will redirect to a page archived by the "Internet Archive".

**Remastersys** was developed by Tony "Fragadelic" Brijeski and discontinued in early 2013.

**This is the begining of a fork**. The legacy version has been posted here for historical purposes, and to make it available both in the original debian package format and in it's source code (see [releases](https://github.com/nerun/remastersys/releases)).

If you try to compile this code with the **package-creator** script provided here, you will notice that the size of the debian packages created are different from the size of the debian packages created by T. Brijeski. This is because in 2013 **dpkg-deb** still used **gzip** to compress debs, and today it uses **xzip**.

The debian packages provided in the [releases](https://github.com/nerun/remastersys/releases) page are the original ones packaged by T. Brijeski.

Do not try to install or run this program on current Debian, it will not work. Version 3.0.0-1 was developed for Debian 6 (Squeeze). The purpose of this fork will be precisely to bring the program to the current versions of the Debian system.

## About me

Daniel Dias Rodrigues, a.k.a. "Nerun"

You have downlaoded this from https://github.com/nerun/remastersys.
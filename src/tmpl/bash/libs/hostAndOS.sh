#!/bin/bash

################################################################################
# The John Operating System Project is the collection of software and configurations
# to generate IoT EcoSystem, like the John Operating System Platform one.
# Copyright (C) 2021 Roberto Pompermaier
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
################################################################################

################################################################################
# Artifact: Robypomper Bash Utils
# Version:  1.0-DEVb
################################################################################

# Detect current OS.
# This method use the OSTYPE env var.
detectOS() {
  case "$OSTYPE" in
  linux*) echo "Unix" ;;
  darwin*) echo "MacOS" ;;
  bsd*) echo "BSD" ;;
  freebsd*) echo "BSD" ;;
  solaris*) echo "Solaris" ;;
  msys*) echo "Win32" ;;
  cygwin*) echo "Win32" ;;
  win32*) echo "Win32" ;;
  *) echo "Unknown: $OSTYPE" ;;
  esac
}

# Detect current OS.
# This method use the 'uname' cmd.
detectOS2() {
  OS="$(uname)"
  case $OS in
  'Linux') echo "Unix" ;;
  'Darwin') echo "MacOS" ;;
  'FreeBSD') echo "BSD" ;;
  'WindowsNT') echo "Win32" ;;
  'SunOS') echo "SunOS" ;;
  'AIX') echo "AIX" ;;
  *) echo "Unknow: $OS" ;;
  esac
}

# Detect current Init System.
# This method check the management command of each Init System know until
# it found the installed one.
detectInitSystem() {
  cmdInit='initctrl'
  cmdSystemd='systemd'
  cmdLaunchd='launchctl'
  cmdSysv='???'
  cmdUpstart='???'

  if command -v $cmdInit &>/dev/null; then
    echo "Init"
  elif command -v $cmdSystemd &>/dev/null; then
    echo "SystemD"
  elif command -v $cmdLaunchd &>/dev/null; then
    echo "LaunchD"
  elif command -v $cmdSysv &>/dev/null; then
    echo "SysV"
  elif command -v $cmdUpstart &>/dev/null; then
    echo "UpStart"
  else
    echo "Unknown"
  fi
}

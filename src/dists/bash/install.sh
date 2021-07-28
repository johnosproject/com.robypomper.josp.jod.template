#!/usr/bin/env bash

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

###############################################################################
# Usage:
# bash $JOD_DIR/install.sh [FORCE]
#
# The ```FORCE``` param, prevent the script fail when current JOD Distribution is
# already installed. When ```FORCE``` param is ```true``` and current JOD Distribution
# is installed, then this script uninstall current JOD Distribution calling the
# [$JOD_DIR/uninstall.sh](#uninstall-jod-daemon) script.
#
# This script, detect the current machine's Init System via the ```$OS_INIT_SYS```
# [JOD Scripts Configs](#jod-scripts-configs) and then install the current
# JOD Distribution as daemon. The underling Init System must run the daemon on
# system boot, and must restart it when it fails.
#
#
# Artifact: JOD Dist Template
# Version:  1.0-DEV
###############################################################################

JOD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
source "$JOD_DIR/scripts/libs/bash.sh"
[ $? -gt 0 ] && logFat "Can't include bash libraries, current dir '$(pwd). Exit'" 255
source "$JOD_DIR/scripts/libs/logs.sh"
source "$JOD_DIR/scripts/libs/filesAndDirs.sh"
includeLib "$JOD_DIR/scripts/libs/hostAndOS.sh"

#DEBUG=true
[[ ! -z "$DEBUG" && "$DEBUG" == true ]] && setupLogsDebug || setupLogs
setupCallerAndScript "$0" "${BASH_SOURCE[0]}"

execScriptConfigs "$JOD_DIR/scripts/jod/jod-script-configs.sh"
execScriptConfigs "$JOD_DIR/scripts/jod/errors.sh"


###############################################################################
logScriptInit

# Load jod_configs.sh, exit if fails
setupJODScriptConfigs "$JOD_DIR/configs/configs.sh"


###############################################################################
logScriptRun

logInf "Check if distribution is already installed..."
INIT_SYS=$(echo "$OS_INIT_SYS" | tr '[:upper:]' '[:lower:]')
logTra "Execute '$JOD_DIR/scripts/init/$INIT_SYS/state-install-jod.sh'"
STATUS_INSTALL=$(bash "$JOD_DIR/scripts/init/$INIT_SYS/state-install-jod.sh" true)
logTra "STATUS_INSTALL=$STATUS_INSTALL"
if [ "$STATUS_INSTALL" = "Installed" ]; then
  if [ "$FORCE" = "false" ]; then
    logWar "Distribution already installed, please uninstall distribution or set FORCE param"
    logScriptEnd $ERR_ALREADY_INSTALLED
  else
    logWar "Distribution already intalled, uninstall it"
    execScriptCommand "$JOD_DIR/uninstall.sh"
  fi
fi

logInf "Execute pre-install.sh..."
[ -f "$JOD_DIR/scripts/pre-install.sh" ] && ( execScriptConfigs $JOD_DIR/scripts/pre-install.sh || logWar "Error executing PRE install script, continue" ) || logInf "PRE install script not found, skipped (missing $JOD_DIR/scripts/pre-install.sh)"

logInf "Installing distribution..."
INIT_SYS=$(echo "$OS_INIT_SYS" | tr '[:upper:]' '[:lower:]')
logTra "INIT_SY=$INIT_SYS"
execScriptCommand "$JOD_DIR/scripts/init/$INIT_SYS/install-jod.sh"

logInf "Distribution installed successfully"

logInf "Execute post-install.sh..."
[ -f "$JOD_DIR/scripts/post-install.sh" ] && ( execScriptConfigs $JOD_DIR/scripts/post-install.sh || logWar "Error executing POST install script, continue" ) || logInf "POST install script not found, skipped (missing $JOD_DIR/scripts/post-install.sh)"


###############################################################################
logScriptEnd

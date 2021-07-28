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
# bash $JOD_DIR/uninstall.sh
#
# This script, detect the current machine's Init System via the ```$OS_INIT_SYS```
# [JOD Scripts Configs](#jod-scripts-configs) and then uninstall the current
# JOD Distribution as daemon. The underling Init System stops running daemon,
# if any.
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

logInf "Check if distribution is already uninstalled..."
INIT_SYS=$(echo "$OS_INIT_SYS" | tr '[:upper:]' '[:lower:]')
logTra "Execute '$JOD_DIR/scripts/init/$INIT_SYS/state-install-jod.sh'"
STATUS_INSTALL=$(bash "$JOD_DIR/scripts/init/$INIT_SYS/state-install-jod.sh" true)
logTra "STATUS_INSTALL=$STATUS_INSTALL"
if [ "$STATUS_INSTALL" = "Not Installed" ]; then
  logWar "Distribution already uninstalled, nothing to do"
  logScriptEnd
fi

logInf "Execute pre-uninstall.sh..."
[ -f "$JOD_DIR/scripts/pre-uninstall.sh" ] && ( execScriptConfigs $JOD_DIR/scripts/pre-uninstall.sh || logWar "Error executing PRE uninstall script, continue" ) || logInf "PRE uninstall script not found, skipped (missing $JOD_DIR/scripts/pre-uninstall.sh)"

logInf "Uninstalling distribution..."
INIT_SYS=$(echo "$OS_INIT_SYS" | tr '[:upper:]' '[:lower:]')
logTra "INIT_SY=$INIT_SYS"
execScriptCommand "$JOD_DIR/scripts/init/$INIT_SYS/uninstall-jod.sh"

logInf "Distribution uninstalled successfully"

logInf "Execute post-uninstall.sh..."
[ -f "$JOD_DIR/scripts/post-uninstall.sh" ] && ( execScriptConfigs $JOD_DIR/scripts/post-uninstall.sh || logWar "Error executing POST uninstall script, continue" ) || logInf "POST uninstall script not found, skipped (missing $JOD_DIR/scripts/post-uninstall.sh)"

###############################################################################
logScriptEnd

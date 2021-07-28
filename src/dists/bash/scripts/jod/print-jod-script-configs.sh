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

###############################################################################
# Usage:
# bash $JOD_DIR/print-jod-script-configs.sh
#
# Print all env vars configured by $JOD_DIR/scripts/jod/jod-script-configs.sh
# script.
#
#
# Artifact: JOD Dist Template
# Version:  1.0-DEV
###############################################################################

JOD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)/.."
source "$JOD_DIR/scripts/libs/bash.sh"
source "$JOD_DIR/scripts/libs/logs.sh"
source "$JOD_DIR/scripts/libs/filesAndDirs.sh"
source "$JOD_DIR/scripts/libs/hostAndOS.sh"

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

logInf "Print JOD scripts configs..."
echo " OS_TYPE      | $OS_TYPE"
echo " OS_INIT_SYS  | $OS_INIT_SYS"
echo " JOD_NAME     | $JOD_NAME"
echo " JOD_NAME_DOT | $JOD_NAME_DOT"
echo " JOD_DIR      | $JOD_DIR"
echo " JOD_YML      | $JOD_YML"
echo " JAVA_EXEC    | $JAVA_EXEC"
echo " JAVA_DIR     | $JAVA_DIR"
echo " JAVA_VER     | $JAVA_VER"

logInf "JOD scripts configs printed successfully"

###############################################################################
logScriptEnd

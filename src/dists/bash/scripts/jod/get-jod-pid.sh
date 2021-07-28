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
# bash $JOD_DIR/scripts/get-jod-pid.sh [NO_LOGS]
#
# Print current distribution process's ID.
#
# NO_LOGS           if true all logs are disabled, only PID is printed
#
#
# Artifact: JOD Dist Template
# Version:  1.0-DEV
###############################################################################

JOD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)/../.."
source "$JOD_DIR/scripts/libs/bash.sh"
source "$JOD_DIR/scripts/libs/logs.sh"
source "$JOD_DIR/scripts/libs/filesAndDirs.sh"
source "$JOD_DIR/scripts/libs/hostAndOS.sh"

# PRE Init NO_LOGS
NO_LOGS=${1:-false}

#DEBUG=true
[ "$NO_LOGS" = "true" ] && setupLogsNone || [[ ! -z "$DEBUG" && "$DEBUG" == true ]] && setupLogsDebug || setupLogs
setupCallerAndScript "$0" "${BASH_SOURCE[0]}"

execScriptConfigs "$JOD_DIR/scripts/jod/jod-script-configs.sh"
execScriptConfigs "$JOD_DIR/scripts/jod/errors.sh"


###############################################################################
logScriptInit

# Init NO_LOGS (PRE initialized)
logScriptParam "NO_LOGS" "$NO_LOGS"

# Load jod_configs.sh, exit if fails
setupJODScriptConfigs "$JOD_DIR/configs/configs.sh"

###############################################################################
logScriptRun

logInf "Querying 'ps' for distribution PID..."
logTra "ps aux | grep -v \"grep\" | grep \"$JOD_NAME_DOT\" | awk '{print $2}'"
JOD_PID=$(ps aux | grep -v "grep" | grep "$JOD_NAME_DOT" | awk '{print $2}')
echo $JOD_PID
logInf "Distribution PID queried successfully"

###############################################################################
logScriptEnd
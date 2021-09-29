#!/usr/bin/env powershell

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
# powershell $JOD_DIR/scripts/get-jod-name.ps1 [NO_LOGS]
#
# Print current distribution object's name.
#
# NO_LOGS           if true all logs are disabled, only PID is printed
#
#
# Artifact: JOD Dist Template
# Version:  1.0.1
###############################################################################

param ([switch] $NO_LOGS=$false)

$JOD_DIR=(get-item $PSScriptRoot ).Parent.Parent.FullName
.$JOD_DIR/scripts/libs/include.ps1 "$JOD_DIR"

## PRE Init NO_LOGS

#$DEBUG=$true
if ( $NO_LOGS ) { INSTALL-LogsNone } elseif (($null -ne $DEBUG) -and ($DEBUG)) { INSTALL-LogsDebug } else { INSTALL-Logs }

setupCallerAndScript $PSCommandPath $MyInvocation.PSCommandPath

."$JOD_DIR/scripts/jod/jod-script-configs.ps1"
execScriptConfigs "$JOD_DIR/scripts/jod/errors.ps1"

###############################################################################
logScriptInit

# Init NO_LOGS (PRE initialized)
logScriptParam "NO_LOGS" "$NO_LOGS"

# Load jod_configs.sh, exit if fails
setupJODScriptConfigs "$JOD_DIR/configs/configs.ps1"

###############################################################################
logScriptRun

logInf "Querying JOD configs for distribution Name..."
$PATTERN="jod.obj.name"
if ($PSVersionTable.PSVersion.Major -gt 5) {
    $line=$(Get-Content -Path "$JOD_YML" | Select-String -Pattern $PATTERN -NoEmphasis | Out-String)
} else {
    $line=$(Get-Content -Path "$JOD_YML" | Select-String -Pattern $PATTERN | Out-String)
}
$JOD_OBJ_NAME=$line.Trim().Substring($PATTERN.length+1).Replace(",","").Replace("'","").Trim()
Write-Host $JOD_OBJ_NAME
logInf "Distribution Name queried successfully"

###############################################################################
logScriptEnd

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
# powershell $JOD_DIST_DIR/scripts/publish.ps1
#             [JOD_DIST_CONFIG_FILE=configs/configs.ps1]
#
# This script assemble and publish JOD Distribution to the
# [JOD Distribution list @ JOSP Docs](https://www.johnosproject.org/docs/References/JOD_Dists/Home)
# web page. This tasks generate the distributable files for current JOD Distribution
# and setup all info to publish it to the JOSP Docs.
#
# The JOD_DIST_CONFIG_FILE can be an absolute file path or a working dir relative
# path. Can be used also path relative to the distribution's project dir, for
# example the path 'configs/configs_test.sh' can be used also outside
# the $JOD_DIST_DIR folder.
#
#
# Artifact: JOD Dist Template
# Version:  1.1.0-DEV
###############################################################################

param (
    [string] $JOD_DIST_CONFIG_FILE="configs/jod_dist_configs.ps1"
)

$JOD_DIST_DIR=(get-item $PSScriptRoot ).parent.FullName
.$JOD_DIST_DIR/scripts/libs/include.ps1 "$JOD_DIST_DIR"
.$JOD_DIST_DIR/scripts/jod_tmpl/include.ps1 "$JOD_DIST_DIR"

#$DEBUG=$true
if ( $NO_LOGS ) { INSTALL-LogsNone } elseif (($DEBUG -ne $null) -and ($DEBUG)) { INSTALL-LogsDebug } else { INSTALL-Logs }

setupCallerAndScript $PSCommandPath $MyInvocation.PSCommandPath

###############################################################################
logScriptInit

# Init JOD_DIST_CONFIG_FILE
if (!(Test-Path $JOD_DIST_CONFIG_FILE)) { $JOD_DIST_CONFIG_FILE="$JOD_DIST_DIR/$JOD_DIST_CONFIG_FILE" }
if (!(Test-Path $JOD_DIST_CONFIG_FILE)) { logFat "File '$JOD_DIST_CONFIG_FILE' not found" $ERR_CONFIGS_NOT_FOUND }
logScriptParam "JOD_DIST_CONFIG_FILE" "$JOD_DIST_CONFIG_FILE"

# Load jod distribution configs, exit if fails
execScriptConfigs $JOD_DIST_CONFIG_FILE

$SRC_DIR="$JOD_DIST_DIR/build/$DIST_ARTIFACT/$DIST_VER"
$DEST_DIR="$JOD_DIST_DIR/build/publications"
$DEST_FILE_TGZ="$JOD_DIST_DIR/build/publications/$DIST_ARTIFACT-$DIST_VER.tgz"
$DEST_FILE_ZIP="$JOD_DIST_DIR/build/publications/$DIST_ARTIFACT-$DIST_VER.zip"

###############################################################################
logScriptRun

logInf "Run build.sh script -> $JOD_DIST_CONFIG_FILE"
execScriptCommand "$JOD_DIST_DIR/scripts/build.ps1" "$JOD_DIST_CONFIG_FILE"

logInf "Compress JOD Distribution to publication dir"
Remove-Item -Recurse "$DEST_DIR" -ea 0
New-Item "$DEST_DIR" -ItemType Directory -ea 0 > /dev/null 2>&1
cd "$SRC_DIR" > /dev/null 2>&1
tar -czvf "$DEST_FILE_TGZ" .  > /dev/null 2>&1   # Supported by windows since 2017
cd -

$SRC_DIR_NAMED = "$JOD_DIST_DIR/build/tmp/$DIST_ARTIFACT-$DIST_VER"
Copy-Item -Path "$SRC_DIR" -Destination "$SRC_DIR_NAMED" -Recurse -ea 0
cd "$SRC_DIR_NAMED" > /dev/null 2>&1
Compress-Archive -Path . -DestinationPath "$DEST_FILE_ZIP" -ea 0 > /dev/null 2>&1
cd -

logWar "Upload disabled because not yet implemented"
Write-Host "####################"
Write-Host "# MANUAL OPERATION #"
Write-Host "####################"
Write-Host "1. Build your JOD Distribution"
Write-Host "   bash scripts/build.sh $JOD_DIST_CONFIG_FILE"
Write-Host "2. Copy results files ({DIST_ARTIFACT}-{DIST_VER}.zip and {DIST_ARTIFACT}-{DIST_VER}.tgz) to public repository"
Write-Host "3. Update public repository with new version links and references"

logInf "JOD Distribution published successfully"

###############################################################################
logScriptEnd

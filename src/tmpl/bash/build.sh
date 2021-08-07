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
# bash $JOD_DIST_DIR/scripts/build.sh [JOD_DIST_CONFIG_FILE=configs/configs.sh]
#
# This script assemble a JOD Distribution based on specified JOD_DIST_CONFIG_FILE
# file.
#
# The JOD_DIST_CONFIG_FILE can be an absolute file path or a working dir relative
# path. Can be used also path relative to the distribution's project dir, for
# example the path 'configs/configs_test.sh' can be used also outside
# the $JOD_DIST_DIR folder.
#
# The generated JOD Distribution is build in 'build/$DEST_ARTIFACT/$DEST_VER'
# folder.
#
# Artifact: JOD Dist Template
# Version:  1.0-DEVb
###############################################################################

JOD_DIST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)/.."
source "$JOD_DIST_DIR/scripts/libs/include.sh" $JOD_DIST_DIR

#DEBUG=true
[[ ! -z "$DEBUG" && "$DEBUG" == true ]] && setupLogsDebug || setupLogs

setupCallerAndScript "$0" "${BASH_SOURCE[0]}"

###############################################################################
logScriptInit

# Init JOD_DIST_CONFIG_FILE
JOD_DIST_CONFIG_FILE=${1:-configs/configs.sh}
[[ ! -f "$JOD_DIST_CONFIG_FILE" ]] && JOD_DIST_CONFIG_FILE="$JOD_DIST_DIR/$JOD_DIST_CONFIG_FILE"
[[ ! -f "$JOD_DIST_CONFIG_FILE" ]] && logFat "Can't find JOD Distribution config's file (missing file: $JOD_DIST_CONFIG_FILE)"
logScriptParam "JOD_DIST_CONFIG_FILE" "$JOD_DIST_CONFIG_FILE"

# Load jod distribution configs, exit if fails
execScriptConfigs $JOD_DIST_CONFIG_FILE

DEST_DIR=$JOD_DIST_DIR/build/$DEST_ARTIFACT/$DEST_VER
CACHE_DIR=$JOD_DIST_DIR/build/cache
JOD_JAR=$CACHE_DIR/jospJOD-$JOD_VER.jar
JOD_URL="https://repo.maven.apache.org/maven2/com/robypomper/josp/jospJOD/$JOD_VER/jospJOD-$JOD_VER.jar"
JOD_DEPS_JAR=$CACHE_DIR//jospJOD-$JOD_VER-deps.jar
JOD_DEPS_URL="https://repo.maven.apache.org/maven2/com/robypomper/josp/jospJOD/$JOD_VER/jospJOD-$JOD_VER-deps.jar"

###############################################################################
logScriptRun

logInf "Build JOD Distribution..."

logDeb "Clean an reacreate JOD Distribution build dirs"
rm -r $DEST_DIR >/dev/null 2>&1
mkdir -p $DEST_DIR
mkdir -p $DEST_DIR/configs
mkdir -p $DEST_DIR/libs
mkdir -p $DEST_DIR/scripts

logDeb "Prepare JOD library"
if [ ! -f "$JOD_JAR" ]; then
  logInf "Download JOD library from $JOD_URL"
  mkdir -p $CACHE_DIR
  curl -s --fail $JOD_URL -o $JOD_JAR
  [ "$?" -ne 0 ] && logFat "Can't download JOD library from '$JOD_URL' url, exit."
fi
cp $JOD_JAR $DEST_DIR/libs/
cp $JOD_JAR $DEST_DIR/jospJOD.jar

logDeb "Prepare JOD dependencies"
if [ ! -f "$JOD_DEPS_JAR" ]; then
  logInf "Download JOD dependencies from $JOD_DEPS_URL"
  mkdir -p $CACHE_DIR
  curl --fail -s $JOD_DEPS_URL -o $JOD_DEPS_JAR
  [ "$?" -ne 0 ] && logFat "Can't download JOD dependencies from '$JOD_URL' url, exit."
fi
cd $DEST_DIR/libs/ && jar xf $JOD_DEPS_JAR && cd - >/dev/null 2>&1 || (
  echo "ERR: Can't prepare JOD Dependencies because can't extract from '$JOD_DEPS_JAR' in to '$DEST_DIR/libs/', exit."
  exit
)

logDeb "Copy JOD Distribution configs"
cp -r $JOD_DIST_DIR/dists/configs/$JOD_CONFIG $DEST_DIR/configs/jod.yml
[ "$?" -ne 0 ] && logFat "Can't include 'jod.yml' to JOD Distribution because can't copy file '$JOD_DIST_DIR/dists/configs/$JOD_CONFIG'"
cp -r $JOD_DIST_DIR/dists/configs/$JOD_STRUCT $DEST_DIR/configs/struct.jod
[ "$?" -ne 0 ] && logFat "Can't include 'struct.jod' to JOD Distribution because can't copy file '$JOD_DIST_DIR/dists/configs/$JOD_STRUCT'"
cp -r $JOD_DIST_DIR/dists/configs/configs.sh_default $DEST_DIR/configs/configs.sh
[ "$?" -ne 0 ] && logFat "Can't include 'configs.sh' to JOD Distribution because can't copy file '$JOD_DIST_DIR/dists/configs/configs.sh_default'"

logDeb "Copy JOD Distribution scripts"
cp -r $JOD_DIST_DIR/dists/scripts/* $DEST_DIR
[ "$?" -ne 0 ] && logFat "Can't include 'scripts' dir to JOD Distribution because can't copy dir '$JOD_DIST_DIR/dists/scripts/*'"

logDeb "Copy JOD Distribution resources"
cp -r $JOD_DIST_DIR/dists/resources/ $DEST_DIR
[ "$?" -ne 0 ] && logFat "Can't include 'resources' dir to JOD Distribution because can't copy dir '$JOD_DIST_DIR/dists/resources/'"

logInf "JOD Distribution built successfully"

###############################################################################
logScriptEnd

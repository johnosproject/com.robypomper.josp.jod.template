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
# bash $JOD_DIST_DIR/scripts/build.sh [JOD_DIST_CONFIG_FILE=configs/jod_dist_configs.sh]
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
source "$JOD_DIST_DIR/scripts/jod_tmpl/include.sh" $JOD_DIST_DIR

#DEBUG=true
[[ ! -z "$DEBUG" && "$DEBUG" == true ]] && setupLogsDebug || setupLogs

setupCallerAndScript "$0" "${BASH_SOURCE[0]}"

###############################################################################
logScriptInit

# Init JOD_DIST_CONFIG_FILE
JOD_DIST_CONFIG_FILE=${1:-configs/jod_dist_configs.sh}
[[ ! -f "$JOD_DIST_CONFIG_FILE" ]] && JOD_DIST_CONFIG_FILE="$JOD_DIST_DIR/$JOD_DIST_CONFIG_FILE"
[[ ! -f "$JOD_DIST_CONFIG_FILE" ]] && logFat "Can't find JOD Distribution config's file (missing file: $JOD_DIST_CONFIG_FILE)"
logScriptParam "JOD_DIST_CONFIG_FILE" "$JOD_DIST_CONFIG_FILE"

# Load jod distribution configs, exit if fails
execScriptConfigs $JOD_DIST_CONFIG_FILE

DEST_DIR="$JOD_DIST_DIR/build/$DEST_ARTIFACT/$DEST_VER"
CACHE_DIR="$JOD_DIST_DIR/build/cache"
JOD_JAR="$CACHE_DIR/jospJOD-$JOD_VER.jar"
JOD_URL="https://repo.maven.apache.org/maven2/com/robypomper/josp/jospJOD/$JOD_VER/jospJOD-$JOD_VER.jar"
JOD_LOCAL_MAVEN="$HOME/.m2/repository/com/robypomper/josp/jospJOD/$JOD_VER/jospJOD-$JOD_VER.jar"
JOD_DEPS_JAR="$CACHE_DIR/jospJOD-$JOD_VER-deps.jar"
JOD_DEPS_URL="https://repo.maven.apache.org/maven2/com/robypomper/josp/jospJOD/$JOD_VER/jospJOD-$JOD_VER-deps.jar"
JOD_DEPS_LOCAL_MAVEN="$HOME/.m2/repository/com/robypomper/josp/jospJOD/$JOD_VER/jospJOD-$JOD_VER-deps.jar"

logInf "Load JOD Distribution configs..."

# JCP_ENV
[ -z "$JCP_ENV" ] && JCP_ENV="stage"
if [ "$JCP_ENV" == "local" ]; then
  JCP_ENV_API="localhost:9001"
  JCP_ENV_AUTH="localhost:8998"
elif [ "$JCP_ENV" == "stage" ]; then
  JCP_ENV_API="api-stage.johnosproject.org"
  JCP_ENV_AUTH="auth-stage.johnosproject.org"
elif [ "$JCP_ENV" == "prod" ]; then
  JCP_ENV_API="api.johnosproject.org"
  JCP_ENV_AUTH="auth.johnosproject.org"
fi

# JCP_ID
[ -z $JCP_ID ] && logFat "JCP Auth id not set. Please check your JOD script's configs file at '$JOD_DIST_CONFIG_FILE', exit." $ERR_MISSING_REQUIREMENTS

# JCP_SECRET
[ -z $JCP_SECRET ] && logFat "JCP Auth secret not set. Please check your JOD script's configs file at '$JOD_DIST_CONFIG_FILE', exit." $ERR_MISSING_REQUIREMENTS

#JOD_NAME

# JOD_ID
# ToDo add check that $JCP_ID is not set for JOD Distribution's build in production mode
[ -n "$JOD_ID" ] && JOD_ID_HW=${JOD_ID::5}

# JOD_EXEC_PULLERS
[ -z "$JOD_EXEC_PULLERS" ] && JOD_EXEC_PULLERS="shell://com.robypomper.josp.jod.executor.PullerUnixShell http://com.robypomper.josp.jod.executor.impls.http.PullerHTTP"

# JOD_EXEC_LISTENERS
[ -z "$JOD_EXEC_LISTENERS" ] && JOD_EXEC_LISTENERS="file://com.robypomper.josp.jod.executor.ListenerFiles"

# JOD_EXEC_EXECUTORS
[ -z "$JOD_EXEC_EXECUTORS" ] && JOD_EXEC_EXECUTORS="shell://com.robypomper.josp.jod.executor.ExecutorUnixShell file://com.robypomper.josp.jod.executor.ExecutorFiles http://com.robypomper.josp.jod.executor.impls.http.ExecutorHTTP"

# JOD_CONFIG_TMPL
[ -z "$JOD_CONFIG_TMPL" ] && JOD_CONFIG_TMPL="dists/configs/jod_TMPL.yml"

# JOD_STRUCT: jod's structure file, path from $JOD_DIST_DIR      ; default: dists/configs/struct.jod
[ -z "$JOD_STRUCT" ] && JOD_STRUCT="dists/configs/struct.jod"

# $JOD_OWNER: josp user's id            ; default: "00000-00000-00000" as Anonymous user
[ -z "$JOD_OWNER" ] && JOD_OWNER="00000-00000-00000"

# $JOD_LOCAL_ENABLED: "true|false"              ; default: "true"
[ -z "$JOD_LOCAL_ENABLED" ] && JOD_LOCAL_ENABLED="true"

# $JOD_CLOUD_ENABLED: "true|false"              ; default: "true"
[ -z "$JOD_CLOUD_ENABLED" ] && JOD_CLOUD_ENABLED="true"

logInf "JOD Distribution configs loaded successfully"

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
  logDeb "Download JOD library from $JOD_URL"
  mkdir -p $CACHE_DIR
  curl --fail -s -m 5 "$JOD_URL" -o "$JOD_JAR"
  if [ "$?" -ne 0 ]; then
    logWar "Can't download JOD library from '$JOD_URL' url, try on local maven repository"
    cp "$JOD_LOCAL_MAVEN" "$JOD_JAR" 2>/dev/null
    if [ "$?" -ne 0 ]; then
      logWar "Can't found JOD library in local maven repository at '$JOD_LOCAL_MAVEN'"
      logFat "Can't get JOD library, exit." $ERR_MISSING_REQUIREMENTS
    fi
  fi
fi
cp $JOD_JAR $DEST_DIR/libs/
cp $JOD_JAR $DEST_DIR/jospJOD.jar

logDeb "Prepare JOD dependencies"
if [ ! -f "$JOD_DEPS_JAR" ]; then
  logDeb "Download JOD dependencies from $JOD_DEPS_URL"
  mkdir -p $CACHE_DIR
  curl --fail -s -m 5 "$JOD_DEPS_URL" -o "$JOD_DEPS_JAR"
  if [ "$?" -ne 0 ]; then
    logWar "Can't download JOD dependencies from '$JOD_DEPS_URL' url, try on local maven repository"
    cp "$JOD_DEPS_LOCAL_MAVEN" "$JOD_DEPS_JAR" 2>/dev/null
    if [ "$?" -ne 0 ]; then
      logWar "Can't found JOD dependencies in local maven repository at '$JOD_DEPS_LOCAL_MAVEN'"
      logFat "Can't get JOD dependencies, exit." $ERR_MISSING_REQUIREMENTS
    fi
  fi
fi
cd $DEST_DIR/libs/ && jar xf $JOD_DEPS_JAR && cd - >/dev/null 2>&1 || (
  echo "ERR: Can't prepare JOD Dependencies because can't extract from '$JOD_DEPS_JAR' in to '$DEST_DIR/libs/', exit."
  exit
)

logDeb "Generate JOD main configs 'jod.yml' file"
sed -e 's|%JCP_ENV_API%|'"$JCP_ENV_API"'|g' \
  -e 's|%JCP_ENV_AUTH%|'"$JCP_ENV_AUTH"'|g' \
  -e 's|%JCP_ID%|'"$JCP_ID"'|g' \
  -e 's|%JCP_SECRET%|'"$JCP_SECRET"'|g' \
  -e 's|%JOD_NAME%|'"$JOD_NAME"'|g' \
  -e 's|%JOD_ID%|'"$JOD_ID"'|g' \
  -e 's|%JOD_ID_HW%|'"$JOD_ID_HW"'|g' \
  -e 's|%JOD_EXEC_PULLERS%|'"$JOD_EXEC_PULLERS"'|g' \
  -e 's|%JOD_EXEC_LISTENERS%|'"$JOD_EXEC_LISTENERS"'|g' \
  -e 's|%JOD_EXEC_EXECUTORS%|'"$JOD_EXEC_EXECUTORS"'|g' \
  -e 's|%JOD_OWNER%|'"$JOD_OWNER"'|g' \
  -e 's|%JOD_LOCAL_ENABLED%|'"$JOD_LOCAL_ENABLED"'|g' \
  -e 's|%JOD_CLOUD_ENABLED%|'"$JOD_CLOUD_ENABLED"'|g' \
  "$JOD_DIST_DIR/$JOD_CONFIG_TMPL" >"$DEST_DIR/configs/jod.yml"

logDeb "Copy JOD Distribution configs"
cp -r "$JOD_DIST_DIR/$JOD_STRUCT" "$DEST_DIR/configs/struct.jod"
[ "$?" -ne 0 ] && logFat "Can't include 'struct.jod' to JOD Distribution because can't copy file '$JOD_DIST_DIR/dists/configs/$JOD_STRUCT'"
cp -r "$JOD_DIST_DIR/dists/configs/jod_configs.sh" "$DEST_DIR/configs/configs.sh"
[ "$?" -ne 0 ] && logFat "Can't include 'configs.sh' to JOD Distribution because can't copy file '$JOD_DIST_DIR/dists/configs/configs.sh_default'"

logDeb "Generate JOD Distribution dist_configs.sh"
echo "#!/bin/bash
export JOD_DIST_NAME='$DEST_ARTIFACT'
export JOD_DIST_VER='$DEST_VER'" >"$DEST_DIR/configs/dist_configs.sh"

logInf "Copy JOD Distribution scripts"
cp -r $JOD_DIST_DIR/dists/scripts/* $DEST_DIR
[ "$?" -ne 0 ] && logFat "Can't include 'scripts' dir to JOD Distribution because can't copy dir '$JOD_DIST_DIR/dists/scripts/*'"

logDeb "Copy JOD Distribution resources"
cp -r $JOD_DIST_DIR/dists/resources/ $DEST_DIR
[ "$?" -ne 0 ] && logFat "Can't include 'resources' dir to JOD Distribution because can't copy dir '$JOD_DIST_DIR/dists/resources/'"

logDeb "Generate JOD Distribution VERSIONS.md"
echo "JOD '$DEST_NAME' Distribution:
JOD Distribution Version:           $DEST_VER
JOD Distribution TEMPLATE Version:  $JOD_TMPL_VERSION
JOD included Version:               $JOD_VER" >"$DEST_DIR/VERSIONS.md"

logInf "JOD Distribution built successfully"

###############################################################################
logScriptEnd

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
# Artifact: JOD Dist Template
# Version:  1.0.1
################################################################################

LOG_ENABLED=false # if true, print log messages

# ####### #
# Loggers #
# ####### #

_log() {
  [ "$LOG_ENABLED" == true ] && echo "LOG: $1" >&2
}

_war() {
  echo "WAR: $1" >&2
}

# ################### #
# Components builders #
# ################### #

#
# COMP=$(buildComponent "Mute" "BooleanState" "listener|puller" "listener.sh param1 param2")
#
# COMP=$(buildComponent "Volume" "RangeState" "listener|puller" "listener.sh param1 param2")
# COMP=$(buildComponent "Volume" "RangeState" "listener|puller" "listener.sh param1 param2" 0 200 15)
#
# COMP=$(buildComponent "MuteA" "BooleanAction" "listener|puller" "listener.sh param1 param2" "executor.sh paramA paramB")
#
# COMP=$(buildComponent "VolumeA" "RangeAction" "listener|puller" "listener.sh param1 param2" 0 200 15 "executor.sh paramA paramB" )
# COMP=$(buildComponent "VolumeA" "RangeAction" "listener|puller" "listener.sh param1 param2" "executor.sh paramA paramB")
#
# CONT_1=$(buildComponent "Audio System" "Container")
# CONT_1=$(addSubComponent "$CONT_1" "$SUB_COMP1")
# CONT_1=$(addSubComponent "$CONT_1" "$SUB_COMP2")
# CONT_2=$(buildComponent "Audio System" "Container")
# CONT_2=$(addSubComponent "$CONT_2" "$SUB_COMP1" "$SUB_COMP2")
# CONT_3=$(buildComponent "Audio System" "Container" "$SUB_COMP1" "$SUB_COMP2" "$SUB_COMP3")
#

buildComponent() {
  COMPONENT_NAME="$1"
  COMPONENT_TYPE="$2"
  shift
  shift
  COMPONENT_ARGS=("$@")

  if [ "$COMPONENT_NAME" == "Root" ]; then
    _buildRoot "$COMPONENT_TYPE" "${COMPONENT_ARGS[@]}"

  else
    case "$COMPONENT_TYPE" in

    "Container")
      _buildContainer "$COMPONENT_NAME" "${COMPONENT_ARGS[@]}"
      ;;

    "BooleanState")
      _buildBooleanState "$COMPONENT_NAME" "${COMPONENT_ARGS[@]}"
      ;;

    "RangeState")
      _buildRangeState "$COMPONENT_NAME" "${COMPONENT_ARGS[@]}"
      ;;

    "BooleanAction")
      _buildBooleanAction "$COMPONENT_NAME" "${COMPONENT_ARGS[@]}"
      ;;

    "RangeAction")
      _buildRangeAction "$COMPONENT_NAME" "${COMPONENT_ARGS[@]}"
      ;;

    *)
      _log "WAR: Unknown component type: $COMPONENT_TYPE"
      echo ""
      ;;
    esac
  fi
}

_buildRoot() {
  if [[ "$#" -eq 3 || "$#" -eq 4 ]]; then
    MODEL=$1
    BRAND=$2
    DESCR=$3
    DESCR_LONG=${4-""}
  else
    _war "Wrong buildRoot() params, please use one of the following prototypes:"
    _war "- buildRoot MODEL BRAND DESCR"
    _war "- buildRoot MODEL BRAND DESCR DESCR_LONG"
    echo "ERR: Can't build '$1' component because wrong params (${#}#: $*)"
    exit
  fi

  _log "> create Root with following args" >&2
  #_log "  - $MODEL"
  #_log "  - $BRAND"
  #_log "  - $DESCR"
  #_log "  - $DESCR_LONG"

  read -r -d '' COMP_STR <<EOM
{
  "model": "$MODEL",
  "brand": "$BRAND",
  "descr": "$DESCR",
  "descr_long": "$DESCR_LONG",

  "contains" : {
  }
}
EOM

  _log "< $COMP_STR"
  echo "$COMP_STR"
}

_buildContainer() {
  if [ "$#" -eq 0 ]; then
    _war "Wrong buildContainer() params, please use one of the following prototypes:"
    _war "- buildContainer COMP_NAME"
    _war "- buildContainer COMP_NAME SUB_COMP_1 ... SUB_COMP_N"
    echo "ERR: Can't build 'Unknown' container because wrong params (${#}#: $*)"
    exit
  fi

  COMP_NAME=$1
  shift
  SUB_COMPONENTS=("$@")

  _log "> create Container '$COMP_NAME' component with following args" >&2
  #for arg in "${SUB_COMPONENTS[@]}"; do _log "  # $arg"; done

  read -r -d '' COMP_STR <<EOM
"$COMP_NAME" : {
  "type": "JODContainer",
  "contains" : {
  }
}
EOM

  for arg in "${SUB_COMPONENTS[@]}"; do COMP_STR=$(addSubComponent "$COMP_STR" "$arg"); done
  echo "$COMP_STR"
  _log "< $COMP_STR"
}

_buildBooleanState() {
  if [ "$#" -eq 3 ]; then
    COMP_NAME=$1
    COMP_STATE_TYPE=$2
    COMP_STATE_EXECUTOR=$3
  else
    _war "Wrong buildBooleanState() params, please use one of the following prototypes:"
    _war "- buildBooleanState COMP_NAME COMP_STATE_TYPE COMP_STATE_EXECUTOR"
    echo "ERR: Can't build '$1' component because wrong params (${#}#: $*)"
    exit
  fi

  _log "> create BooleanState '$COMP_NAME' component with following args" >&2
  #_log "  - $COMP_STATE_TYPE"
  #_log "  - $COMP_STATE_EXECUTOR"

  read -r -d '' COMP_STR <<EOM
"$COMP_NAME" : {
  "type": "BooleanState",
  "$COMP_STATE_TYPE" : "$COMP_STATE_EXECUTOR"
}
EOM

  echo "$COMP_STR"
  _log "< $COMP_STR"
}

_buildRangeState() {
  if [ "$#" -eq 3 ]; then
    COMP_NAME=$1
    COMP_STATE_TYPE=$2
    COMP_STATE_EXECUTOR=$3
    COMP_MIN=0
    COMP_MAX=100
    COMP_STEP=5
  elif [ "$#" -eq 6 ]; then
    COMP_NAME=$1
    COMP_STATE_TYPE=$2
    COMP_STATE_EXECUTOR=$3
    COMP_MIN=$4
    COMP_MAX=$5
    COMP_STEP=$6
  else
    _war "Wrong buildRangeState() params, please use one of the following prototypes:"
    _war "- buildRangeState COMP_NAME COMP_STATE_TYPE COMP_STATE_EXECUTOR"
    _war "- buildRangeState COMP_NAME COMP_STATE_TYPE COMP_STATE_EXECUTOR COMP_MIN COMP_MAX COMP_STEP"
    echo "ERR: Can't build '$1' component because wrong params (${#}#: $*)"
    exit
  fi

  _log "> create RangeState '$COMP_NAME' component with following args" >&2
  #_log "  - $COMP_STATE_TYPE"
  #_log "  - $COMP_STATE_EXECUTOR"
  #_log "  - $COMP_MIN"
  #_log "  - $COMP_MAX"
  #_log "  - $COMP_STEP"

  read -r -d '' COMP_STR <<EOM
"$COMP_NAME" : {
  "type": "RangeState",
  "$COMP_STATE_TYPE" : "$COMP_STATE_EXECUTOR",
  "min": "$COMP_MIN",
  "max": "$COMP_MAX",
  "step": "$COMP_STEP"
}
EOM

  echo "$COMP_STR"
  _log "< $COMP_STR"
}

_buildBooleanAction() {
  if [ "$#" -eq 4 ]; then
    COMP_NAME=$1
    COMP_STATE_TYPE=$2
    COMP_STATE_EXECUTOR=$3
    COMP_ACTION=$4
  else
    _war "Wrong buildBooleanAction() params, please use one of the following prototypes:"
    _war "- buildBooleanAction COMP_NAME COMP_STATE_TYPE COMP_STATE_EXECUTOR COMP_ACTION"
    echo "ERR: Can't build '$1' component because wrong params (${#}#: $*)"
    exit
  fi

  _log "> create BooleanAction '$COMP_NAME' component with following args" >&2
  #_log "  - $COMP_STATE_TYPE"
  #_log "  - $COMP_STATE_EXECUTOR"
  #_log "  - $COMP_ACTION"

  read -r -d '' COMP_STR <<EOM
"$COMP_NAME" : {
  "type": "BooleanAction",
  "$COMP_STATE_TYPE" : "$COMP_STATE_EXECUTOR",
  "executor" : "$COMP_ACTION"
}
EOM

  echo "$COMP_STR"
  _log "< $COMP_STR"
}

_buildRangeAction() {
  if [ "$#" -eq 4 ]; then
    COMP_NAME=$1
    COMP_STATE_TYPE=$2
    COMP_STATE_EXECUTOR=$3
    COMP_MIN=0
    COMP_MAX=100
    COMP_STEP=5
    COMP_EXECUTOR=$4
  elif [ "$#" -eq 7 ]; then
    COMP_NAME=$1
    COMP_STATE_TYPE=$2
    COMP_STATE_EXECUTOR=$3
    COMP_MIN=$4
    COMP_MAX=$5
    COMP_STEP=$6
    COMP_EXECUTOR=$7
  else
    _war "Wrong buildRangeAction() params, please use one of the following prototypes:"
    _war "- buildRangeAction COMP_NAME COMP_STATE_TYPE COMP_STATE_EXECUTOR COMP_EXECUTOR"
    _war "- buildRangeAction COMP_NAME COMP_STATE_TYPE COMP_STATE_EXECUTOR COMP_MIN COMP_MAX COMP_STEP COMP_EXECUTOR"
    echo "ERR: Can't build '$1' component because wrong params (${#}#: $*)"
    exit
  fi

  _log "> create RangeAction '$COMP_NAME' component with following args" >&2
  #_log "  - $COMP_STATE_TYPE"
  #_log "  - $COMP_STATE_EXECUTOR"
  #_log "  - $COMP_MIN"
  #_log "  - $COMP_MAX"
  #_log "  - $COMP_STEP"
  #_log "  - $COMP_EXECUTOR"

  read -r -d '' COMP_STR <<EOM
"$COMP_NAME" : {
  "type": "RangeAction",
  "$COMP_STATE_TYPE" : "$COMP_STATE_EXECUTOR",
  "executor" : "$COMP_EXECUTOR",
  "min": "$COMP_MIN",
  "max": "$COMP_MAX",
  "step": "$COMP_STEP"
}
EOM

  echo "$COMP_STR"
  _log "< $COMP_STR"
}

# ###################### #
# SubComponents managers #
# ###################### #

addSubComponent() {
  if [ "$#" -lt 2 ]; then
    _war "Wrong addSubComponent() params, please use one of the following prototypes:"
    _war "- addSubComponent CONT SUB_COMP_1 ... SUB_COMP_N"
    echo "ERR: Can't build '$1' container because wrong params (${#}#: $*)"
    exit
  fi

  CONT=$1
  shift
  COMPONENT_ARGS=("$@")
  for sub_comp in "${COMPONENT_ARGS[@]}"; do CONT=$(_addSubComponent_Single "$CONT" "$sub_comp"); done

  echo "$CONT"
}

_addSubComponent_Single() {
  if [ "$#" -ne 2 ]; then
    _war "Wrong addSubComponent_Single() params, please use one of the following prototypes:"
    _war "Wrong addSubComponent_Single() CONT params, it must include the 'contains' property:"
    _war "- addSubComponent_Single CONT SUB_COMP"
    echo "ERR: Can't build '$1' container because wrong params (${#}#: $*)"
    exit
  fi

  CONT=$1
  SUB_COMP=$2

  if [[ $CONT != *"contains"* ]]; then
    _war "Wrong addSubComponent_Single() 'CONT' param, it must include the 'contains' property."
    _war "Method addSubComponent_Single CONT can be a component of Container or Root types"
    _war "instead provided params ($CONT)"
    echo "ERR: Can't build '$1' container because wrong 'CONT' param ($CONT)"
    exit
  fi

  #_log "CONT |$CONT|"
  #|"Audio System" : {            // 1st add
  #  "type": "JODContainer",
  #  "contains" : {
  #  }
  #}|
  #|"Audio System" : {            // 2nd add
  #  "type": "JODContainer",
  #  "contains" : {
  #"Mute" : {
  #  "type": "BooleanState",
  #  "listener" : "listener.sh param1 param2"
  #}
  #  }
  #}|
  #_log "SUB_COMP |$SUB_COMP|"
  #|"Mute" : {                    // 1st add
  #  "type": "BooleanState",
  #  "listener" : "listener.sh param1 param2"
  #}|
  #|"Volume" : {                  // 2nd add
  #  "type": "RangeState",
  #  "listener" : "listener.sh param1 param2",
  #  "min": "0",
  #  "max": "200",
  #  "step": "15"
  #}|

  CONTAINS_PATTERN="\"contains\" : {*"

  CONT_INFO=${CONT%$CONTAINS_PATTERN}
  CONT_CONTAINS=${CONT:${#CONT_INFO}}
  #_log "CONT_INFO:        |$CONT_INFO|"
  #|"Audio System" : {            // 1st add
  #  "type": "JODContainer",
  #  |
  #|"Audio System" : {            // 2nd add
  #  "type": "JODContainer",
  #  |
  #_log "CONT_CONTAINS:    |$CONT_CONTAINS|"
  #|"contains" : {                // 1st add
  #  }
  #}|
  #|"contains" : {                // 2nd add
  #"Mute" : {
  #  "type": "BooleanState",
  #  "listener" : "listener.sh param1 param2"
  #}
  #  }
  #}|

  EXISTING=${CONT_CONTAINS#*: {}
  EXISTING="${EXISTING%*\}*\}}"
  EXISTING_TEST=${EXISTING//[$'\t\r\n']/}
  [[ $EXISTING_TEST == *[!\ ]* ]] && EXISTING="$EXISTING," || EXISTING=""
  _log "EXISTING:         |$EXISTING|"
  #||                             // 1st add
  #|                              // 2nd add
  #"Mute" : {
  #  "type": "BooleanState",
  #  "listener" : "listener.sh param1 param2"
  #}
  #  ,|

  CONT_CONTAINS="\"contains\" : { $EXISTING $SUB_COMP }"
  read -r -d '' CONT_CONTAINS <<EOM
  "contains" : {$EXISTING$JOIN
$SUB_COMP
  }
}
EOM

  #_log "CONT_CONTAINS:    |$CONT_CONTAINS|"
  #|"contains" : {                // 1st add
  #"Mute" : {
  #  "type": "BooleanState",
  #  "listener" : "listener.sh param1 param2"
  #}
  #  }
  #}|
  #|"contains" : {                // 2nd add
  #"Mute" : {
  #  "type": "BooleanState",
  #  "listener" : "listener.sh param1 param2"
  #}
  #  ,
  #"Volume" : {
  #  "type": "RangeState",
  #  "listener" : "listener.sh param1 param2",
  #  "min": "0",
  #  "max": "200",
  #  "step": "15"
  #}
  #  }
  #}|

  echo "$CONT_INFO$CONT_CONTAINS"
}

# ########## #
# Formatters #
# ########## #

prettyPrint() {
  echo "$1" | jq . || _war "Error parsing JSON string ($1)"
}

tryPrettyFormat() {
  if command -v jq &>/dev/null; then
    echo "$(echo "$1" | jq .)" || _war "Error parsing JSON string ($1)"
  else
    echo "$1"
  fi
}

prettyFormat() {
  echo "$(echo "$1" | jq .)" || _war "Error parsing JSON string ($1)"
}

# ######## #
# Examples #
# ######## #

## Components creation
#COMP=$(buildComponent "Mute" "BooleanState" "listener" "listener.sh param1 param2")
#COMP=$(buildComponent "Volume" "RangeState" "listener" "listener.sh param1 param2" 0 200 15)
#COMP=$(buildComponent "Volume" "RangeState" "listener" "listener.sh param1 param2")
#COMP=$(buildComponent "MuteA" "BooleanAction" "listener" "listener.sh param1 param2" "executor.sh paramA paramB")
#COMP=$(buildComponent "VolumeA" "RangeAction" "listener" "listener.sh param1 param2" 0 200 15 "executor.sh paramA paramB" )
#COMP=$(buildComponent "VolumeA" "RangeAction" "listener" "listener.sh param1 param2" "executor.sh paramA paramB")

## Container creation
#CONT_1=$(buildComponent "Audio System" "Container")
#CONT_1=$(addSubComponent "$CONT_1" "$SUB_COMP1")
#CONT_1=$(addSubComponent "$CONT_1" "$SUB_COMP2")
#CONT_2=$(buildComponent "Audio System" "Container")
#CONT_2=$(addSubComponent "$CONT_2" "$SUB_COMP1" "$SUB_COMP2")
#CONT_3=$(buildComponent "Audio System" "Container" "$SUB_COMP1" "$SUB_COMP2" "$SUB_COMP3")

## Root creation
#ROOT=$(buildComponent "Root" "$MODEL" "$BRAND" "$DESCR" "$DESCR_LONG")
#ROOT=$(addSubComponent "$ROOT" "$LIGHT_COMP")

## Example 1
## Root > Lampada 1 > Switch
#
## BooleanAction: Switch
#PULLER="http://requestUrl='https://$HUE_GW_ADDR/api/$HUE_GW_DEVELOPER/lights/$COUNT';formatType=JSON;formatPath='$.state.on';formatPathType=JSONPATH;requestIgnoreSSLHosts=true;"
#EXECUTOR="http://requestUrl='http://$HUE_GW_ADDR/api/$HUE_GW_DEVELOPER/lights/$COUNT/state';requestVerb=PUT;formatType=JSON;formatPath='$.[0].success';formatPathType=JSONPATH;requestIgnoreSSLHosts=true;requestBody='{BKSL\\\"onBKSL\\\":%VAL%}'"
#LIGHT_SWITCH=$(buildComponent "Switch" "BooleanAction" "puller" "$PULLER" "$EXECUTOR")
#LIGHT_ONLINE=$(buildComponent "Online" "BooleanAction" "puller" "$PULLER" "$EXECUTOR")
##prettyPrint "{$LIGHT_SWITCH}"
#
## Container: Lampada 1
#LIGHT_COMP=$(buildComponent "Lampada 1" "Container")
#LIGHT_COMP=$(addSubComponent "$LIGHT_COMP" "$LIGHT_SWITCH")
#LIGHT_COMP2=$(buildComponent "Lampada 2" "Container")
#LIGHT_COMP2=$(addSubComponent "$LIGHT_COMP2" "$LIGHT_SWITCH")
##prettyPrint "{$LIGHT_COMP}"
#
## Root
#MODEL="Philips Hue Gateway"
#BRAND="Philips"
#DESCR="The Philips Hue Gateway"
#DESCR_LONG="The Philips Hue Gateway that allow manage and control Hue Lights and all other compatible devices."
#ROOT=$(buildComponent "Root" "$MODEL" "$BRAND" "$DESCR" "$DESCR_LONG")
#ROOT=$(addSubComponent "$ROOT" "$LIGHT_COMP" "$LIGHT_COMP2")
#ROOT=$(tryPrettyFormat "$ROOT")
#echo "$ROOT"

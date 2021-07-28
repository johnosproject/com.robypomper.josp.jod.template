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

# TMPL Customize - START
CURRENT_SCRIPT="$(pwd)/${BASH_SOURCE[0]}"
echo "WAR: Please customize TMPL before call it" \
  && echo "     Update the '${CURRENT_SCRIPT}' file and delete current line" \
  && exit
DEST_ARTIFACT="jod-TMPL"                            # JOD Distribution dir name
DEST_VER="0.1"                                      # JOD Distribution version
JOD_VER="2.2.0"                                     # JOD version (Warning this is only for distribution filename)
ARTIFACT="jospJODExt"                               # Standard
JOD_CONFIG=jod_custom.yml                           # JOD Config file, searched in JOD Distribution and deploy/dists/jospJODExt/_generic/configs/jod dirs
JOD_STRUCT=struct_custom.jod                        # JOD Struct file, searched in JOD Distribution and in deploy/dists/jospJODExt/_generic/configs/struct dirs
# TMPL Customize - END
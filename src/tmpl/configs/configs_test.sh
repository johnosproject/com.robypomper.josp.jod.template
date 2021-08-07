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
# no direct usage, included from other scripts
#
# Example configs script called by JOD builders scripts.
# This configuration can be used to customize the JOD distribution management
# like execution, installation, etc...
#
# To enable this config script, rename it to configs.sh and place in the JOD's
# dist main dir. If not present, then default configs are used.
#
# Artifact: JOD Dist Template
# Version:  1.0-DEVb
###############################################################################

# TMPL Customize - START
DEST_ARTIFACT="jod-test"   # JOD Distribution dir name
DEST_VER="1.0"             # JOD Distribution version
JOD_VER="2.2.0"            # JOD version (Warning this is only for distribution filename)
JOD_CONFIG=jod_test.yml    # JOD Config file, searched in JOD Distribution and deploy/dists/jospJODExt/_generic/configs/jod dirs
JOD_STRUCT=struct_test.jod # JOD Struct file, searched in JOD Distribution and in deploy/dists/jospJODExt/_generic/configs/struct dirs
# TMPL Customize - END

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
# Version:  1.0-DEV
################################################################################

# Generic
ERR_LOAD_SCRIPT_CONFIG=1   # "JOD script config file not found ($JOD_SCRIPT_CONFIG), exit"
ERR_DETECT_SCRIPT_CONFIG=2 # "Can't detect XY ($XY), exit"
ERR_NOT_IMPLEMENTED=3      # "Distribution installation not implemented"

# jod.sh
ERR_ALREADY_RUNNING=1   # "Distribution already running, please shutdown distribution or set FORCE param"

# shutdown.sh
ERR_CANT_SHUTDOWN=1     # "Can't shutdown JOD with PID=$JOD_PID"

# install.sh
ERR_ALREADY_INSTALLED=1 # "Distribution already installed, please uninstall distribution or set FORCE param"

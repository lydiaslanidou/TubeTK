##########################################################################
# Library:   TubeTK
#
# Copyright 2010 Kitware Inc. 28 Corporate Drive,
# Clifton Park, NY, 12065, USA.
#
# All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
##############################################################################

##############################################################################
#
# Configure the following variables and move this file to the directory above
#   the tubetk source directory.
#
set( SITE_NAME "dash5.kitware" )
set( SITE_PLATFORM "Mac10.7-gcc-x86_64" )
set( SITE_BUILD_TYPE "Debug" )
set( SITE_CMAKE_GENERATOR "Unix Makefiles" )
set( SITE_CTEST_MODE "Nightly" ) # one of Experimental, Continuous,
                                      #   or Nightly

set( ENV{DISPLAY} ":0" )

set( SITE_MAKE_COMMAND "make -j3" )
set( SITE_CMAKE_COMMAND "/usr/local/bin/cmake" )
set( SITE_QMAKE_COMMAND "/usr/bin/qmake" )
set( SITE_CTEST_COMMAND "/usr/local/bin/ctest -j3" )

set( SITE_MEMORYCHECK_COMMAND "/usr/bin/valgrind" )
set( SITE_COVERAGE_COMMAND "/usr/bin/gcov" )
set( SITE_KWSTYLE_DIR "/usr/local/bin" )

set( SITE_GIT_COMMAND "/usr/bin/git" )
set( SITE_SVN_COMMAND "/usr/bin/svn" )
set( SITE_CVS_COMMAND "/usr/bin/cvs" )

set( TUBETK_SOURCE_DIR "/Users/Kitware/andinet/Dashboards/tubetk" )
set( TUBETK_BINARY_DIR "/Users/Kitware/andinet/Dashboards/tubetk-${SITE_BUILD_TYPE}" )

set( SITE_EXPERIMENTAL_UPDATE_SUPERBUILD ON )
set( SITE_EXPERIMENTAL_BUILD_TEST ON )
set( SITE_EXPERIMENTAL_STYLE ON )
set( SITE_EXPERIMENTAL_COVERAGE ON )
set( SITE_EXPERIMENTAL_MEMORY ON )

set( SITE_CONTINUOUS_BUILD_TEST OFF ) # Must be ON for any Continuous to run
set( SITE_CONTINUOUS_STYLE ON )
set( SITE_CONTINUOUS_COVERAGE OFF )
set( SITE_CONTINUOUS_MEMORY OFF )

set( SITE_NIGHTLY_BUILD_TEST ON ) # Must be on for any Nightly to run
set( SITE_NIGHTLY_STYLE OFF )
set( SITE_NIGHTLY_COVERAGE OFF )
set( SITE_NIGHTLY_MEMORY OFF )

###########################################################################
#
# The following advanced variables should only be changed by experts
#
set( CTEST_SOURCE_DIRECTORY "${TUBETK_SOURCE_DIR}" )
set( CTEST_BINARY_DIRECTORY "${TUBETK_BINARY_DIR}" )
set( CTEST_COMMAND "${SITE_CTEST_COMMAND}" )

set( SITE_BUILD_NAME "${SITE_PLATFORM}-${SITE_BUILD_TYPE}" )
set( TUBETK_SCRIPT_DIR "${TUBETK_SOURCE_DIR}/CMake/DashboardScripts" )
set( SITE_UPDATE_COMMAND "${GIT_COMMAND}" )
set( GIT_EXECUTABLE "${GIT_COMMAND}" )

set( TubeTK_RUNTIME_PATH "${SITE_KWSTYLE_DIR}" )
set( ENV{PATH} "${TubeTK_RUNTIME_PATH}:$ENV{PATH}" )

set( SITE_CXX_FLAGS
  "-fPIC -fdiagnostics-show-option -W -Wall -Wextra -Wshadow -Wno-system-headers -Wwrite-strings -Wno-deprecated -Woverloaded-virtual" )
set( SITE_C_FLAGS
  "-fPIC -fdiagnostics-show-option -W -Wall -Wextra -Wshadow -Wno-system-headers -Wwrite-strings" )
set( SITE_EXE_LINKER_FLAGS "" )
set( SITE_SHARED_LINKER_FLAGS "" )

set( COVERAGE_FLAGS "-fprofile-arcs -ftest-coverage -lgcov" )
if( SITE_NIGHTLY_COVERAGE
    OR SITE_CONTINUOUS_COVERAGE
    OR SITE_EXPERIMENTAL_COVERAGE )
  set( SITE_C_FLAGS "${SITE_C_FLAGS} ${COVERAGE_FLAGS}" )
  set( SITE_CXX_FLAGS "${SITE_CXX_FLAGS} ${COVERAGE_FLAGS}" )
  set( SITE_EXE_LINKER_FLAGS "${SITE_EXE_LINKER_FLAGS} ${COVERAGE_FLAGS}" )
  set( SITE_SHARED_LINKER_FLAGS
    "${SITE_SHARED_LINKER_FLAGS} ${COVERAGE_FLAGS}" )
endif()

set( SITE_MEMORYCHECK_COMMAND_OPTIONS
  "--gen-suppressions=all --trace-children=yes -q --leak-check=yes --show-reachable=yes --num-callers=50" )
set( SITE_MEMORYCHECK_SUPPRESSIONS_FILE
  "${TUBETK_SCRIPT_DIR}/valgrind_suppressions.txt" )

set( MEMORYCHECK_FLAGS "-g -O0 -ggdb" )
if( SITE_NIGHTLY_MEMORY
    OR SITE_CONTINUOUS_MEMORY
    OR SITE_EXPERIMENTAL_MEMORY )
  set( SITE_C_FLAGS "${SITE_C_FLAGS} ${MEMORYCHECK_FLAGS}" )
  set( SITE_CXX_FLAGS "${SITE_CXX_FLAGS} ${MEMORYCHECK_FLAGS}" )
endif()

if( "${SITE_CTEST_MODE}" STREQUAL "Experimental" )
  if( SITE_EXPERIMENTAL_UPDATE_SUPERBUILD )
    include( "${TUBETK_SCRIPT_DIR}/run_experimental.cmake" )
  else()
    include( "${TUBETK_SCRIPT_DIR}/run_experimental_noSuperBuild.cmake" )
  endif()
elseif( "${SITE_CTEST_MODE}" STREQUAL "Continuous" )
  include( "${TUBETK_SCRIPT_DIR}/run_continuous.cmake" )
elseif( "${SITE_CTEST_MODE}" STREQUAL "Nightly" )
  include( "${TUBETK_SCRIPT_DIR}/run_nightly.cmake" )
endif()
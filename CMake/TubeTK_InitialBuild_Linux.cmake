##############################################################################
#
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
# Configure the following variables and move this file to the directory above
# the TubeTK source directory.
##############################################################################

set( SITE_NAME "Eternia.Kitware" )
set( SITE_PLATFORM "Ubuntu-12.10-64" )
set( SITE_BUILD_TYPE "Release" )
set( SITE_CMAKE_GENERATOR "Unix Makefiles" )

set( TubeTK_GIT_REPOSITORY "http://tubetk.org/TubeTK.git" )
set( TubeTK_SOURCE_DIR "/home/aylward/src/TubeTK" )
set( TubeTK_BINARY_DIR "/home/aylward/src/TubeTK-${SITE_BUILD_TYPE}" )

set( ENV{DISPLAY} ":0" )

set( SITE_MAKE_COMMAND "make" )

set( SITE_CMAKE_COMMAND "/usr/local/bin/cmake" )
set( SITE_CTEST_COMMAND "/usr/local/bin/ctest" )

set( SITE_QMAKE_COMMAND "/usr/local/Trolltech/Qt-4.7.4/bin/qmake" )

set( SITE_GIT_COMMAND "/usr/bin/git" )
set( SITE_SVN_COMMAND "/usr/bin/svn" )

##############################################################################
# The following advanced variables should only be changed by experts.
##############################################################################

set( TubeTK_SCRIPT_DIR "${TubeTK_SOURCE_DIR}/CMake" )

set( SITE_CTEST_MODE "Experimental" )

set( SITE_BUILD_NAME "${SITE_PLATFORM}-${SITE_BUILD_TYPE}" )

set( SITE_UPDATE_COMMAND "${SITE_GIT_COMMAND}" )

set( CTEST_SITE "${SITE_NAME}" )

set( CTEST_BUILD_NAME "${SITE_BUILD_NAME}-BuildTest-New" )

set( CTEST_BUILD_CONFIGURATION "${SITE_BUILD_TYPE}" )
set( CTEST_BUILD_COMMAND "${SITE_MAKE_COMMAND}" )

set( CTEST_SOURCE_DIRECTORY "${TubeTK_SOURCE_DIR}" )
set( CTEST_BINARY_DIRECTORY "${TubeTK_BINARY_DIR}" )

set( CTEST_CMAKE_GENERATOR "${SITE_CMAKE_GENERATOR}" )
set( CTEST_TEST_TIMEOUT 1500 )

set( CTEST_CMAKE_COMMAND "${SITE_CMAKE_COMMAND}" )
set( CTEST_CTEST_COMMAND "${SITE_CTEST_COMMAND}" )
set( CTEST_UPDATE_COMMAND "${SITE_UPDATE_COMMAND}" )
set( CTEST_COMMAND "${SITE_CTEST_COMMAND}" )

set( SITE_CXX_FLAGS "-fPIC -fdiagnostics-show-option -W -Wall -Wextra -Wshadow -Wno-system-headers -Wwrite-strings -Wno-deprecated -Woverloaded-virtual" )
set( SITE_C_FLAGS "-fPIC -fdiagnostics-show-option -W -Wall -Wextra -Wshadow -Wno-system-headers -Wwrite-strings" )
set( SITE_EXE_LINKER_FLAGS "" )
set( SITE_SHARED_LINKER_FLAGS "" )

set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${SITE_C_FLAGS}" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${SITE_CXX_FLAGS}" )
set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${SITE_EXE_LINKER_FLAGS}" )
set( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${SITE_SHARED_LINKER_FLAGS}" )

set( GITCOMMAND "${SITE_GIT_COMMAND}" )
set( GIT_EXECUTABLE "${SITE_GIT_COMMAND}" )
set( SVNCOMMAND "${SITE_SVN_COMMAND}" )
set( CMAKE_GENERATOR ${SITE_CMAKE_GENERATOR} )
set( QT_QMAKE_EXECUTABLE "${SITE_QMAKE_COMMAND}" )

if( NOT EXISTS "${TubeTK_SOURCE_DIR}/CMakeLists.txt" )
  execute_process( COMMAND
    "${SITE_GIT_COMMAND}"
    clone "${TubeTK_GIT_REPOSITORY}" "${TubeTK_SOURCE_DIR}" )
  configure_file(
    ${TubeTK_SCRIPT_DIR}/InitCMakeCache.cmake.in
    ${TubeTK_BINARY_DIR}/InitCMakeCache.cmake IMMEDIATE @ONLY )
  ctest_run_script()
else( NOT EXISTS "${TubeTK_SOURCE_DIR}/CMakeLists.txt" )
  configure_file(
    ${TubeTK_SCRIPT_DIR}/InitCMakeCache.cmake.in
    ${TubeTK_BINARY_DIR}/InitCMakeCache.cmake IMMEDIATE @ONLY )
  ctest_start( "Experimental" )
  ctest_update( SOURCE "${TubeTK_SOURCE_DIR}" )
  ctest_configure( BUILD "${TubeTK_BINARY_DIR}" SOURCE "${TubeTK_SOURCE_DIR}" OPTIONS "-C${TubeTK_BINARY_DIR}/InitCMakeCache.cmake" )
  ctest_read_custom_files( "${TubeTK_BINARY_DIR}" )
  ctest_build( BUILD "${TubeTK_BINARY_DIR}" )
  ctest_test( BUILD "${TubeTK_BINARY_DIR}/TubeTK-build" )
  ctest_submit( PARTS Notes Update Configure Build Test )
endif( NOT EXISTS "${TubeTK_SOURCE_DIR}/CMakeLists.txt" )

set( CTEST_RUN_CURRENT_SCRIPT 0 )

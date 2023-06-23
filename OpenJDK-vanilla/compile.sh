#!/usr/bin/env bash

###################################################
#
# file: compile.sh
#
# @Author:   Iacovos G. Kolokasis
# @Version:  07-03-2021 
# @email:    kolokasis@ics.forth.gr
#
# Compile JVM
#
###################################################

# Define some variables for pretty printing
ESC='\033[' 

# Attributes
NORMAL=0
BOLD=1

# Foreground colors
RED_FG=31
GREEN_FG=32
YELLOW_FG=33

# Presets
BRED=${ESC}${BOLD}';'${RED_FG}'m'
BGREEN=${ESC}${BOLD}';'${GREEN_FG}'m'
BYELLOW=${ESC}${BOLD}';'${YELLOW_FG}'m'
RESET=${ESC}${NORMAL}'m'

CC=gcc-8
CXX=g++-8

function usage()
{
    echo
    echo "Usage:"
    echo -n "      $0 [option ...] [-h]"
    echo
    echo "Options:"
    echo "      -r  Build release without debug symbols"
    echo "      -d  Build with debug symbols"
    echo "      -c  Clean and make"
    echo "      -u  Update JVM in root directory"
    echo "      -h  Show usage"
    echo

    exit 1
}

# Compile without debug symbols
function release() 
{
  make dist-clean
  CC=$CC CXX=$CXX \
  bash ./configure \
    --with-jobs=4 \
    --disable-debug-symbols \
    --with-extra-cflags='-O3' \
    --with-extra-cxxflags='-O3' \
    --with-target-bits=64
  make
}

# Compile with debug symbols and assertions
function debug_symbols_on() 
{
  make dist-clean
  CC=$CC CXX=$CXX \
  bash ./configure \
    --with-debug-level=fastdebug \
    --with-native-debug-symbols=internal \
    --with-target-bits=64 \
    --with-jobs=4
  make
}

function clean_make()
{
  make clean
  make
}

export_env_vars()
{
	local PROJECT_DIR="$(pwd)/../"

	export JAVA_HOME="/usr/lib/jvm/java-8-openjdk"
}

while getopts ":drcmh" opt
do
  case "${opt}" in
    r)
      export_env_vars
      release
      ;;
    d)
      export_env_vars
      debug_symbols_on
      ;;
    c)
      echo "Clean and make"
      export_env_vars
      clean_make
      ;;
    m)
      echo "Make"
      export_env_vars
      make
      ;;
    h)
      usage
      ;;
    *)
      usage
      ;;
  esac
done


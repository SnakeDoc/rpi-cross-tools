#!/usr/bin/env bash
#
# build.sh
#
# This file:
#  - Builds the arm-cortexa7_neonvfpv4-linux-gnueabihf cross-compiler
#
# More info:
#  - https://github.com/SnakeDoc/arm-cortexa7_neonvfpv4-linux-gnueabihf
#
# Version 0.1.0
#
# Authors:
#  - Jason Sipula (https://github.com/SnakeDoc)
#
# Usage:
#  LOG_LEVEL=7 ./build.sh -f /tmp/x -d
#
# Licensed under MIT
# Copyright (c) 2015 Jason Sipula (https://github.com/SnakeDoc)
#
# BASH3 Boilerplate Template
# Licensed under MIT
# Copyright (c) 2013 Kevin van Zonneveld (http://kvz.io)
#

### Configuration
#####################################################################

# Environment variables and their defaults
LOG_LEVEL="${LOG_LEVEL:-6}" # 7 = debug -> 0 = emergency

# Commandline options. This defines the usage page, and is used to parse cli
# opts & defaults from. The parsing is unforgiving so be precise in your syntax
read -r -d '' usage <<-'EOF'
  -f   [arg] Filename to process. Required.
  -t   [arg] Location of tempfile. Default="/tmp/bar"
  -d         Enables debug mode
  -h         This page
EOF

# Set magic variables for current FILE & DIR
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"


### Functions
#####################################################################

function _fmt ()      {
  local color_ok="\x1b[32m"
  local color_bad="\x1b[31m"

  local color="${color_bad}"
  if [ "${1}" = "debug" ] || [ "${1}" = "info" ] || [ "${1}" = "notice" ]; then
    color="${color_ok}"
  fi

  local color_reset="\x1b[0m"
  if [[ "${TERM}" != "xterm"* ]] || [ -t 1 ]; then
    # Don't use colors on pipes or non-recognized terminals
    color=""; color_reset=""
  fi
  echo -e "$(date -u +"%Y-%m-%d %H:%M:%S UTC") ${color}$(printf "[%9s]" ${1})${color_reset}";
}
function emergency () {                             echo "$(_fmt emergency) ${@}" 1>&2 || true; exit 1; }
function alert ()     { [ "${LOG_LEVEL}" -ge 1 ] && echo "$(_fmt alert) ${@}" 1>&2 || true; }
function critical ()  { [ "${LOG_LEVEL}" -ge 2 ] && echo "$(_fmt critical) ${@}" 1>&2 || true; }
function error ()     { [ "${LOG_LEVEL}" -ge 3 ] && echo "$(_fmt error) ${@}" 1>&2 || true; }
function warning ()   { [ "${LOG_LEVEL}" -ge 4 ] && echo "$(_fmt warning) ${@}" 1>&2 || true; }
function notice ()    { [ "${LOG_LEVEL}" -ge 5 ] && echo "$(_fmt notice) ${@}" 1>&2 || true; }
function info ()      { [ "${LOG_LEVEL}" -ge 6 ] && echo "$(_fmt info) ${@}" 1>&2 || true; }
function debug ()     { [ "${LOG_LEVEL}" -ge 7 ] && echo "$(_fmt debug) ${@}" 1>&2 || true; }

function help () {
  echo "" 1>&2
  echo " ${@}" 1>&2
  echo "" 1>&2
  echo "  ${usage}" 1>&2
  echo "" 1>&2
  exit 1
}

function cleanup_before_exit () {
  info "Cleaning up. Done"
}
trap cleanup_before_exit EXIT


### Parse commandline options
#####################################################################

# Translate usage string -> getopts arguments, and set $arg_<flag> defaults
while read line; do
  opt="$(echo "${line}" |awk '{print $1}' |sed -e 's#^-##')"
  if ! echo "${line}" |egrep '\[.*\]' >/dev/null 2>&1; then
    init="0" # it's a flag. init with 0
  else
    opt="${opt}:" # add : if opt has arg
    init=""  # it has an arg. init with ""
  fi
  opts="${opts}${opt}"

  varname="arg_${opt:0:1}"
  if ! echo "${line}" |egrep '\. Default=' >/dev/null 2>&1; then
    eval "${varname}=\"${init}\""
  else
    match="$(echo "${line}" |sed 's#^.*Default=\(\)#\1#g')"
    eval "${varname}=\"${match}\""
  fi
done <<< "${usage}"

# Reset in case getopts has been used previously in the shell.
OPTIND=1

# Overwrite $arg_<flag> defaults with the actual CLI options
while getopts "${opts}" opt; do
  line="$(echo "${usage}" |grep "\-${opt}")"


  [ "${opt}" = "?" ] && help "Invalid use of script: ${@} "
  varname="arg_${opt:0:1}"
  default="${!varname}"

  value="${OPTARG}"
  if [ -z "${OPTARG}" ] && [ "${default}" = "0" ]; then
    value="1"
  fi

  eval "${varname}=\"${value}\""
  debug "cli arg ${varname} = ($default) -> ${!varname}"
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift


### Switches (like -d for debugmode, -h for showing helppage)
#####################################################################

# debug mode
if [ "${arg_d}" = "1" ]; then
  set -o xtrace
  LOG_LEVEL="7"
fi

# help mode
if [ "${arg_h}" = "1" ]; then
  # Help exists with code 1
  help "Help using ${0}"
fi


### Validation (decide what's required for running your script and error out)
#####################################################################

#[ -z "${arg_f}" ]     && help      "Setting a filename with -f is required"
[ -z "${LOG_LEVEL}" ] && emergency "Cannot continue without LOG_LEVEL. "


### Runtime
#####################################################################

# Exit on error. Append ||true if you expect an error.
# set -e is safer than #!/bin/bash -e because that is neutralised if
# someone runs your script like `bash yourscript.sh`
set -o errexit
set -o nounset

# Bash will remember & return the highest exitcode in a chain of pipes.
# This way you can catch the error in case mysqldump fails in `mysqldump |gzip`
set -o pipefail

if [[ "${OSTYPE}" == "darwin"* ]]; then
  info "You are on OSX"
fi

### Begin Program
#####################################################################
if [ ! -d "target" ]; then
    info "Creating target/"
    mkdir -pv target
fi

cd target/

info "Cloning latest crosstool-ng"
if [ ! -d "crosstool-ng" ]; then
    git clone https://github.com/crosstool-ng/crosstool-ng --depth=1
fi
cd crosstool-ng/
git fetch
git reset --hard "origin/master"

./bootstrap
./configure --prefix="${__dir}/target/crosstool-ng-install"
make
make install

PATH="${PATH}:${__dir}/target/crosstool-ng-install/bin"

cd "${__dir}/target"



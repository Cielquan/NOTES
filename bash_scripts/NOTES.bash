#!/usr/bin/env bash

alias
export # makes env vars - `declare -x` ?
local # uses declare arguments - only in functions
readonly # uses the default scope of global even inside functions. declare uses scope local when in a function (unless declare -g).
typeset # = declare

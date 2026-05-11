#!/bin/bash
# Author: Marko Schrempf
set -euo pipefail

# Use env TARGETS to determine one or multiple make targets. Default: pdf
TARGETS="${TARGETS:-pdf}"
# Use env TEMPLATE to change the template folder name. Default: da-base-template
TEMPLATE="${TEMPLATE:-da-base-template}"

export TARGETS
export TEMPLATE

if [ "$#" -gt 0 ]; then
    /scripts/command_wrapper.sh "$@"
else
    /scripts/validator.sh
fi

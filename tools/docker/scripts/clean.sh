#!/bin/bash
# Author: Marko Schrempf
set -euo pipefail

TARGETS="clean"
# Use cmd arg or the env TEMPLATE to change the templates folder name. Default: da-base-template
TEMPLATE="${1:-${TEMPLATE:-da-base-template}}"

export TARGETS
export TEMPLATE

/scripts/validator.sh

#!/bin/bash
# Author: Marko Schrempf
set -euo pipefail

TARGETS="clean-stage"
# Use cmd arg or the env TEMPLATE to change the templates folder name. Default: da-base-template
TEMPLATE="${1:-${TEMPLATE:-da-base-template}}"
# Use cmd arg or the env SOURCE_DIR to change the source folder name. Default: /workspace
SOURCE_DIR="${2:-${SOURCE_DIR:-/workspace}}"
# Use cmd arg or the env OUTPUT_DIR to change the output folder name. Default: Default: SOURCE_DIR/out
OUTPUT_DIR="${3:-${OUTPUT_DIR:-$SOURCE_DIR/out}}"
# Use cmd arg or the env STAGING_DIR to change the staging folder name. Default: staging
STAGING_DIR="${STAGING_DIR:-staging}"

export TARGETS TEMPLATE SOURCE_DIR OUTPUT_DIR STAGING_DIR

/scripts/validator.sh

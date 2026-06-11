#!/bin/bash
# Author: Marko Schrempf
set -euo pipefail

TARGETS_VALUE="${TARGETS:-pdf}"
TEMPLATE_VALUE="${TEMPLATE:-da-base-template}"
SOURCE_DIR_VALUE="${SOURCE_DIR:-/workspace}"
OUTPUT_DIR_VALUE="${OUTPUT_DIR:-$SOURCE_DIR/out}"
STAGING_DIR_VALUE="${STAGING_DIR_VALUE:-staging}"
CLI_TARGET_SEEN=0
CLI_TEMPLATE_SEEN=0
CLI_SOURCE_DIR_SEEN=0
CLI_OUTPUT_DIR_SEEN=0
CLI_STAGING_DIR_SEEN=0

for arg in "$@"; do
    case "$arg" in
        --targets=*)
            TARGETS_VALUE="${arg#--targets=}"
            CLI_TARGET_SEEN=1
            ;;
        --tmpl=*)
            TEMPLATE_VALUE="${arg#--tmpl=}"
            CLI_TEMPLATE_SEEN=1
            ;;
        --src-dir=*)
            SOURCE_DIR_VALUE="${arg#--src-dir=}"
            CLI_SOURCE_DIR_SEEN=1
            ;;
        --out-dir=*)
            OUTPUT_DIR_VALUE="${arg#--out-dir=}"
            CLI_OUTPUT_DIR_SEEN=1
            ;;
        --stage-dir=*)
            STAGING_DIR_VALUE="${arg#--stage-dir=}"
            CLI_STAGING_DIR_SEEN=1
            ;;
        pdf|spellcheck|tex|clean-stage|clean-out|clean-all)
            TARGETS_VALUE="$arg"
            CLI_TARGET_SEEN=1
            ;;
        "")
            ;;
        *)
            if [ "$CLI_TARGET_SEEN" -eq 0 ]; then
                TARGETS_VALUE="$arg"
                CLI_TARGET_SEEN=1
            elif [ "$CLI_TEMPLATE_SEEN" -eq 0 ]; then
                TEMPLATE_VALUE="$arg"
                CLI_TEMPLATE_SEEN=1
            elif [ "$CLI_SOURCE_DIR_SEEN" -eq 0 ]; then
                SOURCE_DIR_VALUE="$arg"
                CLI_SOURCE_DIR_SEEN=1
            elif [ "$CLI_OUTPUT_DIR_SEEN" -eq 0 ]; then
                OUTPUT_DIR_VALUE="$arg"
                CLI_OUTPUT_DIR_SEEN=1
            elif [ "$CLI_STAGING_DIR_SEEN" -eq 0 ]; then
                STAGING_DIR_VALUE="$arg"
                CLI_STAGING_DIR_SEEN=1
            else
                echo "Unknown argument: $arg"
                echo "Usage: build [targets] [tmpl] [src-dir] [out-dir] [stage-dir]"
                echo "   or: build [--targets=targets] [--tmpl=template] [--src-dir=source] [--out-dir=output] [--stage-dir=staging]"
                echo "Targets: pdf,spellcheck,tex,clean-stage,clean-out,clean-all"
                exit 1
            fi
            ;;
    esac
done

export TARGETS="$TARGETS_VALUE"
export TEMPLATE="$TEMPLATE_VALUE"
export SOURCE_DIR="$SOURCE_DIR_VALUE"
export OUTPUT_DIR="$OUTPUT_DIR_VALUE"
export STAGING_DIR="$STAGING_DIR_VALUE"

/scripts/validator.sh

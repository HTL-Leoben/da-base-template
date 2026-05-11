#!/bin/bash
# Author: Marko Schrempf
set -euo pipefail

TARGETS_VALUE="${TARGETS:-pdf}"
TEMPLATE_VALUE="${TEMPLATE:-da-base-template}"
CLI_TARGET_SEEN=0
CLI_TEMPLATE_SEEN=0

for arg in "$@"; do
    case "$arg" in
        --targets=*)
            TARGETS_VALUE="${arg#--targets=}"
            CLI_TARGET_SEEN=1
            ;;
        --template=*)
            TEMPLATE_VALUE="${arg#--template=}"
            CLI_TEMPLATE_SEEN=1
            ;;
        pdf|spellcheck|tex|clean)
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
            else
                echo "Unknown argument: $arg"
                echo "Usage: build [pdf|spellcheck|tex|clean] [template-name]"
                echo "   or: build [--targets=pdf,spellcheck] [--template=template-name]"
                exit 1
            fi
            ;;
    esac
done

export TARGETS="$TARGETS_VALUE"
export TEMPLATE="$TEMPLATE_VALUE"

/scripts/validator.sh

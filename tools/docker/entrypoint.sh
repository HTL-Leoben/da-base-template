#!/bin/bash
set -e

# Use cmd arg or the env TARGET to determine the make target
TARGET="${1:-${TARGET:-pdf}}"

ALLOWED_TARGETS=("pdf" "spellcheck" "tex" "clean")

if [[ " ${ALLOWED_TARGETS[*]} " =~ " ${TARGET} " ]]; then
    make -C da-base-template "$TARGET" SOURCEDIR=/workspace
else
    echo "Invalid target: $TARGET"
    echo "Allowed targets: ${ALLOWED_TARGETS[*]}"
    exit 1
fi

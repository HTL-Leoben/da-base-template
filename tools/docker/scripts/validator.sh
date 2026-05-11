#!/bin/bash
# Author: Marko Schrempf
set -euo pipefail

# Use cmd arg or the env TARGETS to change the make targets. Default: pdf
TARGETS="${TARGETS:-pdf}"
# Use cmd arg or the env TEMPLATE to change the make targets. Default: da-base-template
TEMPLATE="${TEMPLATE:-da-base-template}"
# Use the env SOURCE_DIR to change the directory in the container where the files to build lie
# Must be same as workdir in Dockerfile. Default: /workspace
SOURCE_DIR="${SOURCE_DIR:-/workspace}"
# Possible make targets
ALLOWED_TARGETS=("pdf" "spellcheck" "tex" "clean")
ALLOWED_TARGETS_STRING=$(IFS=', '; echo "${ALLOWED_TARGETS[*]}")

# Check if SOURCE_DIR has the necessary files and folders
if [ -z "$(ls -A "doc" 2>/dev/null)" ] || [ -z "$(ls -A "img" 2>/dev/null)" ] || [ -z "$(ls -A "pdfs" 2>/dev/null)" ] || [ ! -f "literatur.bib" ] || [ ! -f "metadata.yaml" ]; then
    echo "Necessary diploma thesis files/folders are missing/incomplete"
    echo "Please ensure the diploma thesis is correctly set up"
    exit 1
fi

# Check if the template directory exists and has all the necessary files
if [ ! -d "$TEMPLATE" ] || [ ! -f "$TEMPLATE/Makefile" ] || [ -z "$(ls -A "$TEMPLATE/style" 2>/dev/null)" ]; then
    echo "Template is missing/incomplete"
    echo "Please ensure the template is correctly set up"
    exit 1
fi

# Split TARGETS by a comma
IFS=',' read -r -a REQUESTED_TARGETS <<< "$TARGETS"

if [ "${#REQUESTED_TARGETS[@]}" -eq 0 ]; then
    echo "No targets provided"
    echo "Allowed targets: ${ALLOWED_TARGETS_STRING}"
    exit 1
fi

# Execute targets only after they are validated
for raw_target in "${REQUESTED_TARGETS[@]}"; do
    target="$(echo "$raw_target" | xargs)"

    if [ -z "$target" ]; then
        echo "Invalid empty target in TARGETS: $TARGETS"
        echo "Allowed targets: ${ALLOWED_TARGETS_STRING}"
        exit 1
    fi

    if [[ ! " ${ALLOWED_TARGETS[*]} " =~ " ${target} " ]]; then
        echo "Invalid target: $target"
        echo "Allowed targets: ${ALLOWED_TARGETS_STRING}"
        exit 1
    fi
done

# Execute targets only after they are validated
for raw_target in "${REQUESTED_TARGETS[@]}"; do
    target="$(echo "$raw_target" | xargs)"
    make -C "$TEMPLATE" "$target" SOURCEDIR="$SOURCE_DIR"
done

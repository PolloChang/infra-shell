#!/bin/bash
# Script Name: 03-get-all-sha256.sh
# Version: 1.0
# Author: PolloChang
# Date: 2024-12-04
# Description: Get all files sha256 value under path.
# ex1: RESULT_PATH="/var/backup" bash ./03-get-all-sha256.sh
# ex2: ./03-get-all-sha256.sh
# Modified:

# Default values
DEFAULT_RESULT_PATH="/tmp"

export BASE_PATH=" Enter to your path! "
export RESULT_PATH="/tmp/"
export RESULT_PATH="${RESULT_PATH:-$DEFAULT_RESULT_PATH}" # Use RESULT_PATH from environment or default
export RESULT_FILE_NAME="03-result-$(date +%Y%m%d).sha256"

export RESULT_FILE_PATH="${RESULT_PATH}/${RESULT_FILE_NAME}"

# Check if BASE_PATH exists
if [ ! -d "${BASE_PATH}" ]; then
    echo "Error: BASE_PATH '${BASE_PATH}' does not exist. Exiting."
    exit 1
fi

# Check if RESULT_PATH exists; if not, create it
if [ ! -d "${RESULT_PATH}" ]; then
    mkdir -p "${RESULT_PATH}"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create RESULT_PATH '${RESULT_PATH}'. Exiting."
        exit 1
    fi
fi

# Calculate SHA256 for all files and save to result file
find "${BASE_PATH}" -type f -exec sha256sum {} \; | while read hash file; do echo "$hash $(basename "$file")"; done >> "${RESULT_FILE_PATH}"

# Confirm the operation is successful
if [ $? -eq 0 ]; then
    echo "SHA256 checksums saved to '${RESULT_FILE_PATH}'"
else
    echo "Error: Failed to generate SHA256 checksums."
    exit 1
fi
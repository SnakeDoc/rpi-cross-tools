#!/usr/bin/env bash
#
# cross-tools.sh
#
# This file:
#  - Builds the specified cross-compilation toolchain
#

### Begin Program
#####################################################################

# set local variables
XTOOLS_TARGET="${TARGET}-${XTOOLS_NAME}"
XTOOLS_DIR="${TARGET_DIR}/${XTOOLS_TARGET}"

# make sure we have a target
TARGET="${1:-}"
if [ ! -f "${CONFIGS_DIR}/${TARGET}" ]; then
    error "Not a valid target: ${TARGET}"
    error "Exiting..."
    exit 1
fi

# clean the cross-tools out if they already exist
if [ -d "${XTOOLS_DIR}" ]; then
    warn "${XTOOLS_TARGET} already built; cleaning..."
    chmod -R +w "${XTOOLS_DIR}"
    rm -rf "${XTOOLS_DIR}"
fi

cd "${SOURCE_DIR}"
rm -fv .config*

cp -v "${CONFIGS_DIR}/${TARGET}" .config

sed -i 's>\[PREFIX_DIR\]>'"${XTOOLS_DIR}"'>g' .config

sed -i 's>\[THREADS\]>'"${THREADS}"'>g' ./.config

"${CT_NG}" build


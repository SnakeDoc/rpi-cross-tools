#!/usr/bin/env bash
#
# cross-tools.sh
#
# This file:
#  - Builds the specified cross-compilation toolchain
#

### Begin Program
#####################################################################

# make sure we have a target
TARGET="${1:-}"
if [ ! -f "${CONFIGS_DIR}/${TARGET}" ]; then
    error "Not a valid target: ${TARGET}"
    error "Exiting..."
    exit 1
fi

# clean the cross-tools out if they already exist
if [ -d "${TARGET}-${XTOOLS_DIR}" ]; then
    warn "${TARGET}-${XTOOLS_NAME} already built; cleaning..."
    chmod -R +w "${TARGET}-${XTOOLS_DIR}"
    rm -rf "${TARGET}-${XTOOLS_DIR}"
fi

cd "${SOURCE_DIR}"
rm -fv .config*

cp -v "${CONFIGS_DIR}/${TARGET}" .config

sed -i 's>\[PREFIX_DIR\]>'"${TARGET}-${XTOOLS_DIR}"'>g' .config

sed -i 's>\[THREADS\]>'"${THREADS}"'>g' ./.config

"${CT_NG}" build


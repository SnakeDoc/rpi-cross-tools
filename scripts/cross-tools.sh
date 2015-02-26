#!/usr/bin/env bash
#
# cross-tools.sh
#
# This file:
#  - Builds the arm-cortexa7_neonvfpv4-linux-gnueabihf cross-compiler
#

### Begin Program
#####################################################################

# test to see if cross-tools is already built
if [ -d "${XTOOLS_DIR}" ]; then
    error "${XTOOLS_NAME} already built!"
    error "Did you mean to rebuilt it? -- first run: make clean-cross-tools"
    error "Exiting..."
    exit 1
fi

cd "${SOURCE_DIR}"
rm -fv .config*

cp -v "${CONFIGS_DIR}/config-cortexa7_neonvfpv4" .config

sed -i 's>\[PREFIX_DIR\]>'"${XTOOLS_DIR}"'>g' .config

sed -i 's>\[THREADS\]>'"${THREADS}"'>g' ./.config

"${CT_NG}" build


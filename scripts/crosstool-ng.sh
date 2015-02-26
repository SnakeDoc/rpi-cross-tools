#!/usr/bin/env bash
#
# crosstool-ng.sh
#
# This file:
#  - Builds the crosstool-ng tools.
#

### Begin Program
#####################################################################

# test to see if crosstool-ng is already built
if [ -f "${CT_NG}" ]; then
    error "${CT_NG_NAME} already built!"
    error "Did you mean to rebuild it? -- first run: make clean-crosstool-ng"
    error "Exiting..."
    exit 1
fi

cd "${SOURCE_DIR}"

info "Cloning latest crosstool-ng"
if [ ! -d "${CT_NG_SOURCE_DIR}" ]; then
    git clone "${CT_NG_GIT_URL}" --depth=1
fi
cd "${CT_NG_SOURCE_DIR}"

# ensure our local copy is fresh
git fetch
git reset --hard "origin/master"

# modify Makefile.in to ignore 1 level of make recursion
# because we already called make once.
sed -i 's/$(MAKELEVEL),0/$(MAKELEVEL),1/g' Makefile.in

# generate .configure file
./bootstrap

./configure --prefix="${TARGET_DIR}/${CT_NG_NAME}"

make

make install


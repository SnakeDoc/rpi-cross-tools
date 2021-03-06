#!/usr/bin/env bash
#
# archive.sh
#
# This file:
#  - Archives the cross-compilation toolchain
#

### Begin Program
#####################################################################

if [ ! -d "${ARCHIVE_DIR}" ]; then
    info "Creating archive dir"
    mkdir -pv "${ARCHIVE_DIR}"
fi

DATE="$(date +%Y%m%d)"

DIR="${1:-}"
if [ ! -d "${DIR}" ]; then
    error "Directory does not exist >> ${DIR}"
    error "Exiting..."
    exit 1
fi

BASENAME="$(basename ${DIR})"

ARCHIVE_NAME="${BASENAME}.tar.gz"
WRAPPER_ARCHIVE_NAME="${BASENAME}-${DATE}.tar.gz"
ARCHIVE_CURRENT_NAME="${BASENAME}-current.tar.gz"

mkdir -pv "${TARGET_DIR}/temp"

# create tar.gz
info "Creating tar.gz of archive..."
tar -pzcvf "${TARGET_DIR}/temp/${ARCHIVE_NAME}" "${DIR}"

cd "${TARGET_DIR}/temp"
cat > install.sh << "EOF"
#!/usr/bin/env bash
#
# install.sh
#
# This file:
#  - Installs the package to the specified directory
#
# Usage:
#  ./install.sh <where-to-install>
#

FILE="[ARCHIVE_NAME]"
INSTALL_DIR="${1}"

# create install dir if it doesn't exist
if [ ! -d "${INSTALL_DIR}" ]; then
    echo "Attempting to create installation dir..."
    mkdir -pv "${INSTALL_DIR}"
    if [ "${?}" != 0 ]; then
        echo "ERROR: Could not create installation dir!"
        exit 1
    fi
fi

# Test to make sure it's a valid tar.gz file
if [ ! -f "${FILE}" ]; then
    echo "ERROR: ${FILE} does not exist!"
    exit 1
fi

tar -tzf "${FILE}" > /dev/null 2>&1
if [ "${?}" != 0 ]; then
    echo "ERROR: File '${FILE}' is corrupt or invalid!"
    exit 1
fi

# file must be valid if we got here, unpack and install it
tar -zxpvf "${FILE}" -C "${INSTALL_DIR}"
sync
echo

EOF

# insert our archive name
sed -i 's>\[ARCHIVE_NAME\]>'"${ARCHIVE_NAME}"'>g' install.sh

# make sure our install script is executable
chmod +x install.sh

# pack the entire dir
tar -pzcvf "${ARCHIVE_DIR}/${WRAPPER_ARCHIVE_NAME}" *.tar.gz *.sh
sync

# make a synlink to the current archive
ln -svf "${ARCHIVE_DIR}/${WRAPPER_ARCHIVE_NAME}" "${ARCHIVE_DIR}/${ARCHIVE_CURRENT_NAME}"

# checksum the archives
cd "${ARCHIVE_DIR}/"
md5sum * > ./checksum.txt

cd "${TARGET_DIR}"
rm -rf "${TARGET_DIR}/temp"


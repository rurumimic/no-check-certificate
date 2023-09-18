#!/usr/bin/bash

SRC_DIR=${1:-"/vagrant/certs"}
DEST_DIR="/usr/share/pki/ca-trust-source/anchors"

# Validate source directory
if [ ! -d ${SRC_DIR} ]; then
  echo "No directory: \"${SRC_DIR}\""
  echo "[SKIP] Add self-signed certificates"
  exit 0
fi

# Create directory if not exists
if [ ! -d ${DEST_DIR} ]; then
  echo "[ERROR] No directory: \"${DEST_DIR}\"" >> /dev/stderr
  exit 1
fi

echo "Update CA Certificate List"
echo "Processing files in \"${SRC_DIR}\""

# Loop through each certificate file
for FILE in ${SRC_DIR}/*; do
  FILENAME=$(basename -- "$FILE")
  EXTENSION="${FILENAME##*.}"

  if [ "$EXTENSION" == "crt" ] || [ "$EXTENSION" == "pem" ] || [ "$EXTENSION" == "der" ]; then
    cp "$FILE" ${DEST_DIR} && echo "${FILE} => ${DEST_DIR}"
  fi
done

# Update CA Certificate List
update-ca-trust

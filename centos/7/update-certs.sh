#!/bin/bash

SOURCE_DIR=${1:-"/vagrant/certs"}

if [ ! -d ${SOURCE_DIR} ]
then
  echo "[ERROR] No directory: \"${SOURCE_DIR}\"" >> /dev/stderr
  exit 1
fi

CERTS_PATH=/usr/share/pki/ca-trust-source/anchors

echo "Update \"Self-signed\" certificates!"
echo "Finding \".crt\" files in \"${SOURCE_DIR}\""

CERTS=`find ${SOURCE_DIR} -name '*.crt' -type f -print0 | xargs -0`

for FILE in ${CERTS[@]}; do
  echo "${FILE} => ${CERTS_PATH}"
  cp ${FILE} ${CERTS_PATH}
done

update-ca-trust

#!/bin/bash

SOURCE_DIR=${1:-"/vagrant/certs"}

if [ ! -d ${SOURCE_DIR} ]
then
  echo "[INFO] No directory: \"${SOURCE_DIR}\""
  echo "[SKIP] Add self-signed certificates"
  exit 0
fi

CERTS_PATH=/usr/share/pki/ca-trust-source/anchors

echo "Update CA Certificate List"
echo "Finding \".crt\" files in \"${SOURCE_DIR}\""

CERTS=(`find ${SOURCE_DIR} -name '*.crt' -type f -print0 | xargs -0`)

for FILE in ${CERTS[@]}; do
  echo "${FILE} => ${CERTS_PATH}"
  cp ${FILE} ${CERTS_PATH}
done

update-ca-trust

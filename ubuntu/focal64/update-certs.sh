#!/bin/bash

SOURCE_DIR=${1:-"/vagrant/certs"}
CERT_DIR=${2:-"my-certs"}

if [ ! -d ${SOURCE_DIR} ]
then
  echo "[INFO] No directory: \"${SOURCE_DIR}\""
  echo "[SKIP] Add self-signed certificates"
  exit 0
fi

CERTS_PATH=/usr/local/share/ca-certificates/${CERT_DIR}
if [ ! -d ${CERTS_PATH} ]; then
  mkdir $CERTS_PATH
  if [ $? -ne 0 ]; then
    echo "[ERROR] Can't make a directory: \"${CERTS_PATH}\"" >> /dev/stderr
    exit 1
  fi
fi

echo "Update CA Certificate List"
echo "Finding \".crt\" files in \"${SOURCE_DIR}\""

CERTS=(`find ${SOURCE_DIR} -name '*.crt' -type f -print0 | xargs -0`)

for FILE in ${CERTS[@]}; do
  echo "${FILE} => ${CERTS_PATH}"
  cp ${FILE} ${CERTS_PATH}
done

update-ca-certificates

if command -v snap &> /dev/null
then
  echo "Update Snapd’s trusted certificates pool"
  for INDEX in ${!CERTS[@]}; do
    echo "Store ${CERTS[INDEX]} to snapd as \"cert${INDEX}\""
    snap set system store-certs.cert${INDEX}="$(sed -e 's/\r//g' ${CERTS[INDEX]})"
  done
fi

#!/usr/bin/bash

SRC_DIR=${1:-"/vagrant/certs"}
CERT_DIR=${2:-"corporate"}
DEST_DIR="/usr/local/share/ca-certificates/${CERT_DIR}"

# Validate source directory
if [ ! -d ${SRC_DIR} ]; then
  echo "No directory: \"${SRC_DIR}\""
  echo "[SKIP] Add self-signed certificates"
  exit 0
fi

apt-get install -y ca-certificates openssl

# Create directory if not exists
if [ ! -d ${DEST_DIR} ]; then
  mkdir -p ${DEST_DIR}
  if [ $? -ne 0 ]; then
    echo "[ERROR] Can't make directory: \"${DEST_DIR}\"" >> /dev/stderr
    exit 1
  fi
fi

echo "Update CA Certificate List"
echo "Processing files in \"${SRC_DIR}\""

# Loop through each certificate file
for FILE in ${SRC_DIR}/*; do
  FILENAME=$(basename -- "$FILE")
  EXTENSION="${FILENAME##*.}"

  if [ "$EXTENSION" == "crt" ] || [ "$EXTENSION" == "pem" ] || [ "$EXTENSION" == "der" ]; then
    case $EXTENSION in
      crt)
        cp "$FILE" ${DEST_DIR} && echo "${FILE} => ${DEST_DIR}"
        ;;
      pem)
        cp "$FILE" "${DEST_DIR}/${FILENAME%.pem}.crt" && echo "${FILE} => ${DEST_DIR}/${FILENAME%.pem}.crt"
        ;;
      der)
        openssl x509 -inform der -in "$FILE" -out "${DEST_DIR}/${FILENAME%.der}.crt" && echo "${FILE} => ${DEST_DIR}/${FILENAME%.der}.crt"
        ;;
    esac
  fi
done

# Update CA Certificate List
update-ca-certificates

# Update Snapd’s trusted certificates pool, if snap is installed
if command -v snap &> /dev/null; then
  echo "Update Snapd’s trusted certificates pool"
  CERTS=(`find ${DEST_DIR} -name '*.crt' -type f -print0 | xargs -0`)
  for INDEX in ${!CERTS[@]}; do
    echo "Store ${CERTS[INDEX]} to snapd as \"cert${INDEX}\""
    snap set system store-certs.cert${INDEX}="$(sed -e 's/\r//g' ${CERTS[INDEX]})"
  done
fi

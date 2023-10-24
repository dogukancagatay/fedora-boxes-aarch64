#!/usr/bin/env bash

set -e
# set -x

if [ $# -ne 4 ]; then
  cat <<_EOT_
Usage:
  VAGRANT_ACCESS_TOKEN="xxyyzz" $0 <box_name> <version> <version-description> <box-filepath>
_EOT_
  exit 1
fi

[ -z "$VAGRANT_USERNAME" ] && export VAGRANT_USERNAME="asdf"
[ -z "$VAGRANT_PROVIDER_NAME" ] && export VAGRANT_PROVIDER_NAME="parallels"
[ -x "$VAGRANT_ACCESS_TOKEN" ] && echo "VAGRANT_ACCESS_TOKEN variable is required. Create from https://app.vagrantup.com/settings/security" && exit 1

API_BASE_URL="https://app.vagrantup.com/api/v2"

# fedora-35-aarch64
BOX_NAME=$1
# 0.0.2
VERSION=$2
VERSION_DESCRIPTION=$3
BOX_FILEPATH=$4
BOX_ARCH="arm64"

# Extract box checksum
BOX_CHECKSUM_TYPE="sha256"
BOX_CHECKSUM=$(awk '{print $1}' "${BOX_FILEPATH}.${BOX_CHECKSUM_TYPE}")

# Try to create the box
echo -e "\nCreate box on Vagrant cloud: ${BOX_NAME}\n"
curl \
  --request POST \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer ${VAGRANT_ACCESS_TOKEN}" \
  --data '{ "box": { "username": "'${VAGRANT_USERNAME}'", "name": "'${BOX_NAME}'", "is_private": false, "short_description": "A generic Fedora box for aarch64 and Parallels provider. Source: https://github.com/dogukancagatay/fedora-boxes-aarch64" } }' \
  "${API_BASE_URL}/boxes" || echo "Box already exists: ${BOX_NAME}"

# Delete the version
echo -e "\nDelete the version (${VERSION}) from Vagrant cloud\n"
curl \
  --request DELETE \
  "${API_BASE_URL}/box/${VAGRANT_USERNAME}/${BOX_NAME}/version/${VERSION}?access_token=${VAGRANT_ACCESS_TOKEN}" || echo "No version: ${VERSION} "

# Create a new version
echo -e "\n\nCreate a new version (${VERSION}) on Vagrant cloud\n"
curl \
  --header "Content-Type: application/json" \
  --data "{ \"version\": { \"version\": \"${VERSION}\", \"description\": \"${VERSION_DESCRIPTION}\" } }" \
  "${API_BASE_URL}/box/${VAGRANT_USERNAME}/${BOX_NAME}/versions?access_token=${VAGRANT_ACCESS_TOKEN}"

# Create a provider
echo -e "\n\nCreate a provider (${VAGRANT_PROVIDER_NAME}) for version (${VERSION}) on Vagrant cloud\n"
curl \
  --header "Content-Type: application/json" \
  --data "{ \"provider\": { \"checksum\": \"${BOX_CHECKSUM}\", \"checksum_type\": \"${BOX_CHECKSUM_TYPE}\", \"name\": \"${VAGRANT_PROVIDER_NAME}\", \"architecture\": \"${BOX_ARCH}\", \"default_architecture\": true } }" \
  "${API_BASE_URL}/box/${VAGRANT_USERNAME}/${BOX_NAME}/version/${VERSION}/providers?access_token=${VAGRANT_ACCESS_TOKEN}"

# Upload the box file
echo -e "\n\nGet upload URL for the box (${BOX_FILEPATH})\n"
UPLOAD_PATH=$(curl -fsSL "${API_BASE_URL}/box/${VAGRANT_USERNAME}/${BOX_NAME}/version/${VERSION}/provider/${VAGRANT_PROVIDER_NAME}/${BOX_ARCH}/upload?access_token=${VAGRANT_ACCESS_TOKEN}" | jq -r '.upload_path')

echo '{ "upload_path": "'"${UPLOAD_PATH}"'" }'

echo -e "\nUpload box: ${VAGRANT_USERNAME}/${BOX_NAME}\n"
curl -X PUT --progress-bar --upload-file "${BOX_FILEPATH}" "${UPLOAD_PATH}"

echo "Done!"

echo -e "\nVersion is not released yet. Release it from the link below.\n\n"
echo -e "\thttps://app.vagrantup.com/${VAGRANT_USERNAME}/boxes/${BOX_NAME}/versions/${VERSION}/edit\n"

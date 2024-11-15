#!/usr/bin/env bash

set -e
# set -x

# fedora-35-aarch64
BOX_NAME=$1
# 0.0.2
VERSION=$2
VERSION_DESCRIPTION=$3
BOX_FILEPATH=$4

# Extract box checksum
BOX_CHECKSUM_TYPE="SHA256"
BOX_CHECKSUM=$(awk '{print $1}' "${BOX_FILEPATH}.${BOX_CHECKSUM_TYPE}")

API_BASE_URL="https://api.cloud.hashicorp.com/vagrant/2022-09-30"
HCP_VAGRANT_REGISTRY="dcagatay"
VAGRANT_PROVIDER_NAME="parallels"
VAGRANT_BOX_ARCH="arm64"
AUTHORIZATION_HEADER="Authorization: Bearer $(hcp auth print-access-token)"
DESCRIPTION="A generic Fedora box for aarch64 and Parallels provider. Source: https://github.com/dogukancagatay/fedora-boxes-aarch64"

# Try to create the box
echo -e "\nCreate box on Vagrant cloud: ${BOX_NAME}\n"
curl \
  --request POST \
  --header "${AUTHORIZATION_HEADER}" \
  --data '
{
  "name": "'"${BOX_NAME}"'",
  "is_private": false,
  "short_description": "",
  "description": "'"${DESCRIPTION}"'"
}' \
  "${API_BASE_URL}/registry/${HCP_VAGRANT_REGISTRY}/boxes"

# Delete the version
echo -e "\nDelete the version (${VERSION}) from Vagrant cloud\n"
curl \
  --request DELETE \
  --header "${AUTHORIZATION_HEADER}" \
  "${API_BASE_URL}/registry/${HCP_VAGRANT_REGISTRY}/box/${BOX_NAME}/version/${VERSION}"

# Create a new version
echo -e "\n\nCreate a new version (${VERSION}) on Vagrant cloud\n"
curl \
  --request POST \
  --header "${AUTHORIZATION_HEADER}" \
  --data '
{
  "name": "'"${VERSION}"'",
  "description": "'"${VERSION_DESCRIPTION}"'"
}' \
  "${API_BASE_URL}/registry/${HCP_VAGRANT_REGISTRY}/box/${BOX_NAME}/versions"

# Create a new provider
echo -e "\n\nCreate a provider (${VAGRANT_PROVIDER_NAME}) for version (${VERSION}) on Vagrant cloud\n"
curl \
  --request POST \
  --header "${AUTHORIZATION_HEADER}" \
  --data '
{
  "name": "'"${VAGRANT_PROVIDER_NAME}"'"
}' \
  "${API_BASE_URL}/registry/${HCP_VAGRANT_REGISTRY}/box/${BOX_NAME}/version/${VERSION}/providers"

# Create a new architecture
echo -e "\n\nCreate an architecture(${VAGRANT_BOX_ARCH}) for provider (${VAGRANT_PROVIDER_NAME}) on Vagrant cloud\n"
curl \
  --request POST \
  --header "${AUTHORIZATION_HEADER}" \
  --data '
{
  "architecture_type": "'"${VAGRANT_BOX_ARCH}"'",
  "default": true,
  "box_data": {
    "checksum_type": "'"${BOX_CHECKSUM_TYPE}"'",
    "checksum": "'"${BOX_CHECKSUM}"'"
  }
}' \
  "${API_BASE_URL}/registry/${HCP_VAGRANT_REGISTRY}/box/${BOX_NAME}/version/${VERSION}/provider/${VAGRANT_PROVIDER_NAME}/architectures"

# Upload the box file
echo -e "\n\nGet upload URL for the box (${BOX_FILEPATH})\n"
UPLOAD_PATH=$(
  curl \
    --header "${AUTHORIZATION_HEADER}" \
    "${API_BASE_URL}/registry/${HCP_VAGRANT_REGISTRY}/box/${BOX_NAME}/version/${VERSION}/provider/${VAGRANT_PROVIDER_NAME}/architecture/${VAGRANT_BOX_ARCH}/upload" \
    | jq -r '.url'
)

echo '{ "upload_path": "'"${UPLOAD_PATH}"'" }' | jq

echo -e "\nUpload box: ${HCP_VAGRANT_REGISTRY}/${BOX_NAME}\n"
curl -X PUT --progress-bar --upload-file "${BOX_FILEPATH}" "${UPLOAD_PATH}"

echo -e "\nRelease the version (${VERSION}) on HCP Vagrant Cloud\n"
curl \
  --request PUT \
  --header "${AUTHORIZATION_HEADER}" \
  "${API_BASE_URL}/registry/${HCP_VAGRANT_REGISTRY}/box/${BOX_NAME}/version/${VERSION}/release"

echo "Done!"

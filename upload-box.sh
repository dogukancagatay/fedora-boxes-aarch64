#!/usr/bin/env bash

set -ex

if [ $# -ne 3 ]; then
  cat <<_EOT_
Usage:
  VAGRANT_ACCESS_TOKEN="xxyyzz" $0 <box_name> <version> <box_filepath>
_EOT_
  exit 1
fi

[ ! -n "$VAGRANT_USERNAME" ] && export VAGRANT_USERNAME="asdf"
[ ! -n "$VAGRANT_PROVIDER_NAME" ] && export VAGRANT_PROVIDER_NAME="parallels"
[ ! -n "$VAGRANT_ACCESS_TOKEN" ] && echo "VAGRANT_ACCESS_TOKEN variable is required. Create from https://app.vagrantup.com/settings/security" && exit 1

# fedora-35-aarch64
BOX_NAME=$1
# 0.0.2
VERSION=$2
BOX_FILEPATH=$3

UPLOAD_PATH=`curl -fsSL "https://vagrantcloud.com/api/v1/box/${VAGRANT_USERNAME}/${BOX_NAME}/version/${VERSION}/provider/${VAGRANT_PROVIDER_NAME}/upload?access_token=${VAGRANT_ACCESS_TOKEN}" | jq -r '.upload_path'`

echo "Uploading to $UPLOAD_PATH ..."

curl -X PUT --upload-file $BOX_FILEPATH $UPLOAD_PATH

echo "done!"

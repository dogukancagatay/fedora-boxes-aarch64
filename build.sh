#!/usr/bin/env bash

set -e
# set -x

[ ! -n "$ARCH" ] && export ARCH="aarch64"
[ ! -n "$VERSION" ] && export VERSION="0.0.2"
[ ! -n "$PACKER_ON_ERROR" ] && export PACKER_ON_ERROR="cleanup"
[ ! -n "$PACKER_MAX_PROCS" ] && export PACKER_MAX_PROCS="2"
[ ! -n "$PACKER_CACHE_DIR" ] && export PACKER_CACHE_DIR="./packer_cache/"
[ ! -n "$PACKER_LOG" ] && export PACKER_LOG="1"

export PACKER_LOG_PATH="./logs/generic-parallels-log-`date +'%Y%m%d.%H.%M.%S'`.txt"
mkdir -p `dirname $PACKER_LOG_PATH` output

BOX_TYPE="${1}"
if [[ -z "${BOX_TYPE}" ]]; then
    BOX_TYPE=fedora35
fi

# packer build -force -on-error=$PACKER_ON_ERROR -only="generic-${BOX_TYPE}-${ARCH}-parallels" generic-parallels-${ARCH}.json
packer build -force -on-error=$PACKER_ON_ERROR -only="parallels-iso.generic-${BOX_TYPE}-${ARCH}-parallels" generic-parallels-aarch64.pkr.hcl
packer build -force -on-error=$PACKER_ON_ERROR -only="parallels-iso.generic-fedora36-${ARCH}-parallels" generic-parallels-aarch64.pkr.hcl

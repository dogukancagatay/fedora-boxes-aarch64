#!/bin/bash -eux

FEDORA_VERSION="$(cat /etc/fedora-release | awk '{print $3}')"
HNAME="fedora${FEDORA_VERSION}"

printf "\n127.0.0.1    ${HNAME} ${HNAME}.localdomain\n" >> /etc/hosts
echo "${HNAME}.localdomain" > /etc/hostname
hostnamectl set-hostname ${HNAME}.localdomain

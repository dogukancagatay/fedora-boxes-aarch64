#!/bin/bash -eux

FEDORA_EOL_VERSIONS='34 35';
FEDORA_VERSION="$(cat /etc/fedora-release | awk '{print $3}')"

if [[ $FEDORA_EOL_VERSIONS =~ (^|[[:space:]])$FEDORA_VERSION($|[[:space:]]) ]]; then
    sed -E -i 's|^metalink=|#metalink=|' \
        /etc/yum.repos.d/{fedora.repo,fedora-updates.repo,fedora-modular.repo,fedora-updates-modular.repo}
    sed -E -i 's|^#baseurl=http://download.example/pub/|baseurl=https://dl.fedoraproject.org/pub/archive/|' \
        /etc/yum.repos.d/{fedora.repo,fedora-updates.repo,fedora-modular.repo,fedora-updates-modular.repo}
fi

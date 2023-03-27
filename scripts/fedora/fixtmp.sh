#!/bin/bash

service_exists() {
    local n=$1
    if [[ $(systemctl list-units --all -t service --full --no-legend "$n.service" | sed 's/^\s*//g' | cut -f1 -d' ') == $n.service ]]; then
        return 0
    else
        return 1
    fi
}

# Otherwise the tmp directory is a tiny ramdisk.
if service_exists tmp.mount; then
    systemctl disable --now tmp.mount
    systemctl mask tmp.mount
fi

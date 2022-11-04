#!/bin/bash -ux

retry() {
  local COUNT=1
  local DELAY=0
  local RESULT=0
  while [[ "${COUNT}" -le 10 ]]; do
    [[ "${RESULT}" -ne 0 ]] && {
      [ "`which tput 2> /dev/null`" != "" ] && [ -n "$TERM" ] && tput setaf 1
      echo -e "\n${*} failed... retrying ${COUNT} of 10.\n" >&2
      [ "`which tput 2> /dev/null`" != "" ] && [ -n "$TERM" ] && tput sgr0
    }
    "${@}" && { RESULT=0 && break; } || RESULT="${?}"
    COUNT="$((COUNT + 1))"

    # Increase the delay with each iteration.
    DELAY="$((DELAY + 10))"
    sleep $DELAY
  done

  [[ "${COUNT}" -gt 10 ]] && {
    [ "`which tput 2> /dev/null`" != "" ] && [ -n "$TERM" ] && tput setaf 1
    echo -e "\nThe command failed 10 times.\n" >&2
    [ "`which tput 2> /dev/null`" != "" ] && [ -n "$TERM" ] && tput sgr0
  }

  return "${RESULT}"
}

# Needed to check whether we're running atop Parallels.
retry dnf install --assumeyes dmidecode patch tar

# Bail if we are not running atop Parallels.
if [[ `dmidecode -s system-product-name` != "Parallels Virtual Platform" ]] \
  && [[ `dmidecode -s system-product-name` != "Parallels ARM Virtual Machine" ]]; then
    exit 0
fi

# Read in the version number.
PARALLELSVERSION=`cat /root/parallels-tools-version.txt`

echo "Installing the Parallels tools, version $PARALLELSVERSION."

mkdir -p /mnt/parallels/
mount -o loop /root/parallels-tools-linux.iso /mnt/parallels/
PTOOLS_DIR="/mnt/parallels"

# if kernel version is >= 6.x apply patch
if  [[ `uname -r` == 6.* ]]; then
  echo "Will patch parallels-tools with 6.x patch for current kernel (`uname -r`)"

  PTOOLS_DIR="/tmp/parallels-tool"
  cp -r /mnt/parallels $PTOOLS_DIR

  mkdir -p $PTOOLS_DIR/prl_mod
  tar -xzf $PTOOLS_DIR/kmods/prl_mod.tar.gz -C $PTOOLS_DIR/prl_mod
  tee <<EOF > $PTOOLS_DIR/prl_mod/parallels-tools-kernel-6.0.x.patch
diff -puNr parallels-tools-18.0.2.53077.orig/prl_fs_freeze/Snapshot/Guest/Linux/prl_freeze/prl_fs_freeze.c parallels-tools-18.0.2.53077/prl_fs_freeze/Snapshot/Guest/Linux/prl_freeze/prl_fs_freeze.c
--- parallels-tools-18.0.2.53077.orig/prl_fs_freeze/Snapshot/Guest/Linux/prl_freeze/prl_fs_freeze.c	2022-09-06 18:43:52.000000000 +0000
+++ parallels-tools-18.0.2.53077/prl_fs_freeze/Snapshot/Guest/Linux/prl_freeze/prl_fs_freeze.c	2022-10-17 02:08:48.625690162 +0000
@@ -306,7 +306,11 @@ int seq_show(struct seq_file *file, void
 	char buf[BDEVNAME_SIZE];

 	fsb = list_entry((struct list_head*)data, struct frozen_sb, list);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(6, 0, 0)
+	snprintf(buf, sizeof(buf), "%pg", fsb->sb->s_bdev);
+#else
 	bdevname(fsb->sb->s_bdev, buf);
+#endif
 	seq_printf(file, "%s\n", buf);
 	return 0;
 }

EOF
  patch $PTOOLS_DIR/prl_mod/prl_fs_freeze/Snapshot/Guest/Linux/prl_freeze/prl_fs_freeze.c < $PTOOLS_DIR/prl_mod/parallels-tools-kernel-6.0.x.patch || echo "Patch failed not modifying"
  mv $PTOOLS_DIR/kmods/prl_mod.tar.gz $PTOOLS_DIR/kmods/prl_mod.tar.gz.orig
  cd $PTOOLS_DIR/prl_mod
  tar -czf ../kmods/prl_mod.tar.gz .
fi

$PTOOLS_DIR/install --install-unattended-with-deps --verbose --progress \
  || (status="$?" ; echo "Parallels tools installation failed. Error: $status" ; cat /var/log/parallels-tools-install.log ; exit $status)

umount /mnt/parallels/
rm -rf /mnt/parallels $PTOOLS_DIR

# Cleanup the guest additions.
rm --force /root/parallels-tools-linux.iso
rm --force /root/parallels-tools-version.txt

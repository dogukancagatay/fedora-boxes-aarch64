text
reboot --eject
lang en_US.UTF-8
keyboard us
timezone US/Pacific
rootpw --plaintext vagrant
user --name=vagrant --password=vagrant --plaintext

zerombr
clearpart --all --initlabel --disklabel=msdos
autopart --noswap --type=btrfs

firewall --enabled --service=ssh
network --device eth0 --bootproto dhcp --noipv6 --hostname=fedora37.localdomain
bootloader --timeout=1 --append="net.ifnames=0 biosdevname=0 no_timer_check vga=792 nomodeset text"

# When this release is no longer available from mirrors, enable the archive url.
url --url=https://dl.fedoraproject.org/pub/fedora/linux/releases/37/Server/aarch64/os/
# url --url=https://mirrors.edge.kernel.org/fedora/releases/37/Server/aarch64/os/
# url --url=https://dl.fedoraproject.org/pub/archive/fedora/linux/releases/37/Everything/aarch64/os/

%packages
net-tools
@core
-mcelog
-usbutils
-microcode_ctl
-smartmontools
-plymouth
-plymouth-core-libs
-plymouth-scripts
%end

%post

# Create the vagrant user account.
/usr/sbin/useradd vagrant
echo "vagrant" | passwd --stdin vagrant

# Make the future vagrant user a sudo master.
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

sed -i -e "s/.*PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
sed -i -e "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config

%end

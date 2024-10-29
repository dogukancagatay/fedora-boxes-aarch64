# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box_check_update = true
  config.vm.synced_folder ".", "/vagrant", disabled: true
  # config.vm.synced_folder "~/", "/media/psf/Home"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider :parallels do |v, override|
    v.memory = 2048
    v.cpus = 2

    # Set disk size
    v.customize "post-import", ["set", :id, "--device-set", "hdd0", "--no-fs-resize", "--size", "50000"]

    v.linked_clone = false
    v.update_guest_tools = false
    v.customize ["set", :id, "--on-window-close", "keep-running"]
    v.customize ["set", :id, "--startup-view", "headless"]
    v.customize ["set", :id, "--pmu-virt", "on"]
    v.customize ["set", :id, "--faster-vm", "on"]
    v.customize ["set", :id, "--resource-quota", "unlimited"]
    v.customize ["set", :id, "--time-sync", "on"]
    # v.customize ["set", :id, "--shared-clipboard", "off"]
    # v.customize ["set", :id, "--sync-host-printers", "off"]
  end

  config.vm.provision "shell", inline: <<-SHELL
    # Upgrading kernel might break parallels-tools kernel modules
    # dnf upgrade -y

    # Resize root fs (cloud-utils-growpart)
    growpart /dev/sda 3
    btrfs filesystem resize max /
  SHELL

end

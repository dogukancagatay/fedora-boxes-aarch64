# -*- mode: ruby -*-
# vi: set ft=ruby :

box_label = "#{ENV['BOX_LABEL'] || 'fedora-39-aarch64'}"
box_name = "#{ENV['BOX_LABEL'] ? 'local' : 'dcagatay'}/#{box_label}"

Vagrant.configure("2") do |config|
  config.vm.box = "#{box_name}"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder "~/", "/media/psf/Home"

  config.vm.provider "parallels" do |prl|
    prl.name = "#{box_label}"
    prl.update_guest_tools = false
    prl.memory = 2048
    prl.cpus = 2
    prl.linked_clone = false
    prl.customize ["set", :id, "--on-window-close", "keep-running"]
    prl.customize ["set", :id, "--startup-view", "headless"]
    prl.customize ["set", :id, "--pmu-virt", "on"]
    prl.customize ["set", :id, "--faster-vm", "on"]
    prl.customize ["set", :id, "--resource-quota", "unlimited"]
    prl.customize ["set", :id, "--time-sync", "on"]
    prl.customize ["set", :id, "--shared-clipboard", "off"]
    prl.customize ["set", :id, "--sync-host-printers", "off"]
    prl.customize "post-import", ["set", :id, "--device-set", "hdd0", "--no-fs-resize", "--size", "50000"]
  end

  config.vm.provision "shell", inline: <<-SHELL
    # Upgrading kernel might break parallels-tools kernel modules
    # dnf upgrade -y

    # Resize root fs
    # dnf install cloud-utils-growpart -y
    growpart /dev/sda 3
    btrfs filesystem resize max /
  SHELL

end

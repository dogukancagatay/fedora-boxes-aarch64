variable "box_version" {
  type    = string
  default = "${env("VERSION")}"
}

source "parallels-iso" "generic-fedora35-aarch64-parallels" {
  vm_name                    = "generic-fedora35-aarch64-parallels"
  output_directory           = "output/generic-fedora35-aarch64-parallels"
  cpus                       = 2
  memory                     = 2048
  disk_size                  = 32768
  iso_checksum               = "file:https://dl.fedoraproject.org/pub/fedora/linux/releases/35/Server/aarch64/iso/Fedora-Server-35-1.2-aarch64-CHECKSUM"
  iso_url                    = "https://dl.fedoraproject.org/pub/fedora/linux/releases/35/Server/aarch64/iso/Fedora-Server-netinst-aarch64-35-1.2.iso"
  boot_keygroup_interval     = "1s"
  boot_wait                  = "20s"
  boot_command               = [
    "<up>e<wait1><down><down><wait2><leftCtrlOn>e<leftCtrlOff> ",
    "<wait>inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/generic.fedora35.vagrant.ks ",
    "<wait>biosdevname=0 ",
    "<wait>net.ifnames=0 ",
    "<wait><leftCtrlOn>x<leftCtrlOff>"
  ]
  guest_os_type              = "fedora-core"
  parallels_tools_flavor     = "lin-arm"
  hard_drive_interface       = "sata"
  http_directory             = "http"
  parallels_tools_guest_path = "/root/parallels-tools-linux.iso"
  parallels_tools_mode       = "upload"
  prlctl                     = [
    ["set", "{{ .Name }}", "--adaptive-hypervisor", "on"],
    ["set", "{{ .Name }}", "--3d-accelerate", "off"],
    ["set", "{{ .Name }}", "--videosize", "16"],
    ["set", "{{ .Name }}", "--pmu-virt", "on"],
    ["set", "{{ .Name }}", "--faster-vm", "on"]
  ]
  prlctl_version_file        = "/root/parallels-tools-version.txt"
  shutdown_command           = "echo 'vagrant' | sudo -S shutdown -P now"
  skip_compaction            = false
  ssh_username               = "root"
  ssh_password               = "vagrant"
  ssh_port                   = 22
  ssh_timeout                = "3600s"
}

source "parallels-iso" "generic-fedora36-aarch64-parallels" {
  vm_name                    = "generic-fedora36-aarch64-parallels"
  output_directory           = "output/generic-fedora36-aarch64-parallels"
  cpus                       = 2
  memory                     = 2048
  disk_size                  = 32768
  iso_checksum               = "file:https://dl.fedoraproject.org/pub/fedora/linux/releases/36/Server/aarch64/iso/Fedora-Server-36-1.5-aarch64-CHECKSUM"
  iso_url                    = "https://dl.fedoraproject.org/pub/fedora/linux/releases/36/Server/aarch64/iso/Fedora-Server-netinst-aarch64-36-1.5.iso"
  boot_keygroup_interval     = "1s"
  boot_wait                  = "20s"
  boot_command               = [
    "<up>e<wait1><down><down><wait2><leftCtrlOn>e<leftCtrlOff> ",
    "<wait>inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/generic.fedora36.vagrant.ks ",
    "<wait>biosdevname=0 ",
    "<wait>net.ifnames=0 ",
    "<wait><leftCtrlOn>x<leftCtrlOff>"
  ]
  guest_os_type              = "fedora-core"
  parallels_tools_flavor     = "lin-arm"
  hard_drive_interface       = "sata"
  http_directory             = "http"
  parallels_tools_guest_path = "/root/parallels-tools-linux.iso"
  parallels_tools_mode       = "upload"
  prlctl                     = [
    ["set", "{{ .Name }}", "--adaptive-hypervisor", "on"],
    ["set", "{{ .Name }}", "--3d-accelerate", "off"],
    ["set", "{{ .Name }}", "--videosize", "16"],
    ["set", "{{ .Name }}", "--pmu-virt", "on"],
    ["set", "{{ .Name }}", "--faster-vm", "on"]
  ]
  prlctl_version_file        = "/root/parallels-tools-version.txt"
  shutdown_command           = "echo 'vagrant' | sudo -S shutdown -P now"
  skip_compaction            = false
  ssh_username               = "root"
  ssh_password               = "vagrant"
  ssh_port                   = 22
  ssh_timeout                = "3600s"
}

source "parallels-iso" "generic-fedora37b-aarch64-parallels" {
  vm_name                    = "generic-fedora37b-aarch64-parallels"
  output_directory           = "output/generic-fedora37b-aarch64-parallels"
  cpus                       = 2
  memory                     = 2048
  disk_size                  = 32768
  iso_checksum               = "file:https://dl.fedoraproject.org/pub/fedora/linux/development/37/Server/aarch64/iso/Fedora-Server-37-aarch64-20221108.n.0-CHECKSUM"
  iso_url                    = "https://dl.fedoraproject.org/pub/fedora/linux/development/37/Server/aarch64/iso/Fedora-Server-netinst-aarch64-37-20221108.n.0.iso"
  boot_keygroup_interval     = "1s"
  boot_wait                  = "15s"
  boot_command               = [
    "<up>e<wait1><down><down><wait2><leftCtrlOn>e<leftCtrlOff> ",
    "<wait>inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/generic.fedora37b.vagrant.ks ",
    "<wait>biosdevname=0 ",
    "<wait>net.ifnames=0 ",
    "<wait><leftCtrlOn>x<leftCtrlOff>"
  ]
  guest_os_type              = "fedora-core"
  parallels_tools_flavor     = "lin-arm"
  hard_drive_interface       = "sata"
  http_directory             = "http"
  parallels_tools_guest_path = "/root/parallels-tools-linux.iso"
  parallels_tools_mode       = "upload"
  prlctl                     = [
    ["set", "{{ .Name }}", "--adaptive-hypervisor", "on"],
    ["set", "{{ .Name }}", "--3d-accelerate", "off"],
    ["set", "{{ .Name }}", "--videosize", "16"],
    ["set", "{{ .Name }}", "--pmu-virt", "on"],
    ["set", "{{ .Name }}", "--faster-vm", "on"]
  ]
  prlctl_version_file        = "/root/parallels-tools-version.txt"
  shutdown_command           = "echo 'vagrant' | sudo -S shutdown -P now"
  skip_compaction            = false
  ssh_username               = "root"
  ssh_password               = "vagrant"
  ssh_port                   = 22
  ssh_timeout                = "3600s"
}

build {
  sources = [
    "source.parallels-iso.generic-fedora35-aarch64-parallels",
    "source.parallels-iso.generic-fedora36-aarch64-parallels",
    "source.parallels-iso.generic-fedora37b-aarch64-parallels"
  ]

  provisioner "shell" {
    expect_disconnect   = "true"
    scripts             = [
      "scripts/fedora/fixdns.sh",
      "scripts/fedora/hostname.sh",
      "scripts/fedora/dnf.sh"
    ]
    start_retry_timeout = "45m"
    timeout             = "2h0m0s"
  }

  provisioner "shell" {
    expect_disconnect   = "true"
    pause_before        = "2m0s"
    scripts             = [
      "scripts/fedora/fixtmp.sh",
      "scripts/fedora/base.sh"
    ]
    start_retry_timeout = "45m"
    timeout             = "2h0m0s"
  }

  provisioner "shell" {
    expect_disconnect   = "true"
    pause_before        = "2m0s"
    scripts             = [
      "scripts/fedora/kernel.sh",
      "scripts/fedora/vga.sh",
      "scripts/fedora/virtualbox.sh",
      "scripts/fedora/parallels.sh",
      "scripts/fedora/vmware.sh",
      "scripts/fedora/qemu.sh",
      "scripts/fedora/vagrant.sh",
      "scripts/fedora/tuning.sh",
      "scripts/fedora/cleanup.sh"]
    start_retry_timeout = "45m"
    timeout             = "2h0m0s"
  }

  provisioner "shell" {
    expect_disconnect   = "true"
    scripts             = [
      "scripts/common/motd.sh",
      "scripts/common/keys.sh",
      "scripts/common/machine.sh",
      "scripts/common/leases.sh",
      "scripts/common/localtime.sh",
      "scripts/common/zerodisk.sh",
      "scripts/common/lockout.sh"
    ]
    start_retry_timeout = "45m"
    timeout             = "2h0m0s"
  }


  # could not parse template for following block: "template: hcl2_upgrade:9: unexpected \"\\\\\" in operand"
  post-processors {
    post-processor "shell-local" {
      inline = ["prl_disk_tool merge --hdd output/{{build_name}}/{{build_name}}.pvm/harddisk1.hdd", "prl_disk_tool compact --hdd output/{{build_name}}/{{build_name}}.pvm/harddisk1.hdd"]
    }
    post-processor "vagrant" {
      keep_input_artifact  = false
      compression_level    = 9
      include              = ["tpl/generic/info.json"]
      output               = "output/generic-{{split build_name \"-\" 1}}-{{split build_name \"-\" 2}}-{{split build_name \"-\" 3}}-${var.box_version}.box"
      vagrantfile_template = "tpl/generic-{{split build_name \"-\" 1}}.rb"
    }
    post-processor "checksum" {
      keep_input_artifact = false
      checksum_types      = ["sha256"]
      output              = "output/generic-{{split build_name \"-\" 1}}-{{split build_name \"-\" 2}}-{{split build_name \"-\" 3}}-${var.box_version}.box.sha256"
    }
  }
}

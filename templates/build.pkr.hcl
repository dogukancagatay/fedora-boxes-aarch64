build {
  sources = [
    "source.parallels-iso.generic-fedora35-aarch64-parallels",
    "source.parallels-iso.generic-fedora36-aarch64-parallels",
    "source.parallels-iso.generic-fedora37-aarch64-parallels",
    "source.parallels-iso.generic-fedora38-aarch64-parallels",
    "source.parallels-iso.generic-fedora39-aarch64-parallels",
  ]

  provisioner "shell" {
    expect_disconnect   = "true"
    scripts             = [
      "scripts/fedora/fixdns.sh",
      # "scripts/fedora/hostname.sh",
      "scripts/fedora/set-archive-repo.sh",
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
      # "scripts/fedora/virtualbox.sh",
      "scripts/fedora/parallels.sh",
      # "scripts/fedora/vmware.sh",
      # "scripts/fedora/qemu.sh",
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


  # Merge and compact VM disks (workaround for running Parallels VMs with Vagrant)
  post-processors {
    post-processor "shell-local" {
      inline = [
        "prl_disk_tool merge --hdd output/{{build_name}}/{{build_name}}.pvm/harddisk1.hdd",
        "prl_disk_tool compact --hdd output/{{build_name}}/{{build_name}}.pvm/harddisk1.hdd"
      ]
    }
    # Output Vagrant box
    post-processor "vagrant" {
      keep_input_artifact  = false
      compression_level    = 9
      include              = ["tpl/generic/info.json"]
      output               = "output/generic-{{split build_name \"-\" 1}}-{{split build_name \"-\" 2}}-{{split build_name \"-\" 3}}-${var.box_version}.box"
      vagrantfile_template = "tpl/generic-{{split build_name \"-\" 1}}.rb"
    }
    # Output box checksum file
    post-processor "checksum" {
      keep_input_artifact = false
      checksum_types      = ["sha256"]
      output              = "output/generic-{{split build_name \"-\" 1}}-{{split build_name \"-\" 2}}-{{split build_name \"-\" 3}}-${var.box_version}.box.sha256"
    }
  }
}

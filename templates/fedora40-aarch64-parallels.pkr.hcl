source "parallels-iso" "generic-fedora40-aarch64-parallels" {
  vm_name                = "generic-fedora40-aarch64-parallels"
  output_directory       = "output/generic-fedora40-aarch64-parallels"
  cpus                   = 2
  memory                 = 2048
  disk_size              = 32768
  iso_checksum           = "file:https://dl.fedoraproject.org/pub/fedora/linux/releases/40/Server/aarch64/iso/Fedora-Server-40-1.14-aarch64-CHECKSUM"
  iso_url                = "https://download.fedoraproject.org/pub/fedora/linux/releases/40/Server/aarch64/iso/Fedora-Server-netinst-aarch64-40-1.14.iso"
  boot_keygroup_interval = "1s"
  boot_wait              = "10s"
  boot_command = [
    "<up>e<wait1><down><down><wait2><leftCtrlOn>e<leftCtrlOff> ",
    "<wait>inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/generic.fedora40.vagrant.ks ",
    "<wait>inst.text ",
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
  prlctl = [
    ["set", "{{ .Name }}", "--adaptive-hypervisor", "on"],
    ["set", "{{ .Name }}", "--3d-accelerate", "off"],
    ["set", "{{ .Name }}", "--videosize", "16"],
    ["set", "{{ .Name }}", "--pmu-virt", "on"],
    ["set", "{{ .Name }}", "--faster-vm", "on"]
  ]
  prlctl_version_file = "/root/parallels-tools-version.txt"
  shutdown_command    = "echo 'vagrant' | sudo -S shutdown -P now"
  skip_compaction     = false
  ssh_username        = "root"
  ssh_password        = "vagrant"
  ssh_port            = 22
  ssh_timeout         = "3600s"
}

locals {
  box_slug       = "{{split build_name \"-\" 1}}" # e.g. fedora39
  box_arch       = "{{split build_name \"-\" 2}}" # e.g. aarch64
  box_provider   = "{{split build_name \"-\" 3}}" # e.g. parallels
  box_file_name  = "generic-{{split build_name \"-\" 1}}-{{split build_name \"-\" 2}}-{{split build_name \"-\" 3}}-${var.box_version}.box"
  fedora_version = "{{split build_name \"-\" 1 | replace \"fedora\" \"\" 1 }}" # e.g. 39 for fedora39 and 41b for fedora41b
}

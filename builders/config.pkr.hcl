packer {
  required_plugins {
    parallels = {
      version = ">= 1.0.3"
      source  = "github.com/hashicorp/parallels"
    }
    vagrant = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

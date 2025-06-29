packer {
  required_plugins {
    openstack = {
      version = "= 1.1.2"
      source  = "github.com/hashicorp/openstack"
    }
  }
}

locals { 
  buildtime = formatdate("YYYYMMDD-hhmm", timestamp())
}

source "openstack" "config-agent-jammy" {
  flavor              = "g1.small"
  image_name          = "config-agent-jammy-${local.buildtime}"
  source_image_name   = "ubuntu-jammy"
  ssh_username        = "ubuntu"
  floating_ip_network = "common_provider"
  reuse_ips           = true
  security_groups     = ["allow-all"]
}

build {
  sources = ["source.openstack.config-agent-jammy"]
  provisioner "file" {
    source = "./scripts"
    destination = "/tmp"
  }
  provisioner "shell" {
    inline = ["sudo -E bash /tmp/scripts/main.sh"]
  }
}


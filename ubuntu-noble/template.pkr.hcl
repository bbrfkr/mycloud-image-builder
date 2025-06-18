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

source "openstack" "ubuntu-noble" {
  flavor              = "g1.small"
  image_name          = "ubuntu-noble-${local.buildtime}"
  source_image_name   = "ubuntu-noble"
  ssh_username        = "ubuntu"
  floating_ip_network = "common_provider"
  networks            = ["e79618e1-836f-42d5-bfa8-fe90e4987213"] # stg-network
  reuse_ips           = true
  security_groups     = ["allow-all"]
}

build {
  sources = ["source.openstack.ubuntu-noble"]
  provisioner "file" {
    source = "./scripts"
    destination = "/tmp"
  }
  provisioner "shell" {
    inline = ["sudo -E bash /tmp/scripts/main.sh"]
  }
}


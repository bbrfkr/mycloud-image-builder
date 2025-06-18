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

source "openstack" "ubuntu-noble-docker" {
  flavor              = "g1.tiny"
  image_name          = "ubuntu-noble-docker-${local.buildtime}"
  source_image_name   = "ubuntu-noble"
  ssh_username        = "ubuntu"
  floating_ip_network = "common_provider"
  reuse_ips           = true
  networks            = ["e79618e1-836f-42d5-bfa8-fe90e4987213"] # stg-network
  security_groups     = ["allow-all"]
}

build {
  sources = ["source.openstack.ubuntu-noble-docker"]
  provisioner "file" {
    source = "./scripts"
    destination = "/tmp"
  }
  provisioner "shell" {
    inline = ["sudo -E bash /tmp/scripts/01-os.sh"]
  }
  provisioner "shell" {
    inline = ["sudo -E bash /tmp/scripts/02-docker.sh"]
  }
  provisioner "shell" {
    inline = ["sudo -E bash /tmp/scripts/99-cleanup.sh"]
  }
}


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

variable "os_env" {
  default = env("OS_ENV")
}

source "openstack" "config-agent-noble" {
  flavor              = "g1.small"
  image_name          = "config-agent-noble-${local.buildtime}"
  source_image_name   = "ubuntu-noble"
  ssh_username        = "ubuntu"
  floating_ip_network = "common_provider"
  reuse_ips           = false
  networks            = [
    var.os_env == "prod" ?
    "e79618e1-836f-42d5-bfa8-fe90e4987213" :
    "10012c6f-d6c8-40d2-a6b8-af5709b6f468"
  ] # stg-network
  security_groups     = ["allow-all"]
}

build {
  sources = ["source.openstack.config-agent-noble"]
  provisioner "file" {
    source = "./scripts"
    destination = "/tmp"
  }
  provisioner "shell" {
    inline = ["sudo -E bash /tmp/scripts/main.sh"]
  }
}


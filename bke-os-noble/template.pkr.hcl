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
  bke_version = "2.1.0"
  containerd_version = "2.2.1"
  runc_version = "1.3.4"
  cni_plugins_version = "1.9.0"
  nerdctl_version = "2.2.0"
}

variable "os_env" {
  default = env("OS_ENV")
}

source "openstack" "bke-os" {
  flavor              = "g1.small"
  image_name          = "bke-os-v${local.bke_version}-${local.buildtime}"
  source_image_name   = var.os_env == "prod" ? "config-agent-noble-20251224-0647" : "config-agent-noble-20251223-0333"
  ssh_username        = "ubuntu"
  floating_ip_network = "common_provider"
  networks            = [
    var.os_env == "prod" ?
    "e79618e1-836f-42d5-bfa8-fe90e4987213" :
    "10012c6f-d6c8-40d2-a6b8-af5709b6f468"
  ] # stg-network
  reuse_ips           = false
  security_groups     = ["allow-all"]
  metadata            = {
    "os_distro": "bke-os-v${local.bke_version}"
  }
}

build {
  sources = ["source.openstack.bke-os"]
  provisioner "file" {
    source = "./scripts"
    destination = "/tmp"
  }
  provisioner "shell" {
    environment_vars = [
      "CONTAINERD_VERSION=${local.containerd_version}",
      "RUNC_VERSION=${local.runc_version}",
      "CNI_PLUGINS_VERSION=${local.cni_plugins_version}",
      "NERDCTL_VERSION=${local.nerdctl_version}",
    ]
    inline = ["sudo -E bash /tmp/scripts/main.sh"]
  }
}


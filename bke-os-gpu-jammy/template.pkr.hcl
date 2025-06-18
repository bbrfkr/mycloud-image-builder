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
  bke_version = "2.0.0"
  containerd_version = "1.7.11"
  runc_version = "1.1.10"
  cni_plugins_version = "1.4.0"
  nerdctl_version = "1.7.2"
  cuda_toolkit_version = "12-4"
}

source "openstack" "bke-os-gpu" {
  flavor              = "p1.large"
  image_name          = "bke-os-gpu-v${local.bke_version}-${local.buildtime}"
  source_image_name   = "config-agent-jammy"
  ssh_username        = "ubuntu"
  floating_ip_network = "common_provider"
  networks            = ["e79618e1-836f-42d5-bfa8-fe90e4987213"] # stg-network
  reuse_ips           = true
  security_groups     = ["allow-all"]
  metadata            = {
    "os_distro": "bke-os-v${local.bke_version}"
  }
}

build {
  sources = ["source.openstack.bke-os-gpu"]
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
      "CUDA_TOOLKIT_VERSION=${local.cuda_toolkit_version}",
    ]
    inline = ["sudo -E bash /tmp/scripts/main.sh"]
  }
}

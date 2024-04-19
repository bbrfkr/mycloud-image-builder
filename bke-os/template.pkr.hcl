locals { 
  buildtime = formatdate("YYYYMMDD-hhmm", timestamp())
  bke_version = "2.0.0"
  containerd_version = "1.7.11"
  runc_version = "1.1.10"
  cni_plugins_version = "1.4.0"
  nerdctl_version = "1.7.2"
}

source "openstack" "bke-os" {
  flavor              = "g1.small"
  image_name          = "bke-os-v${local.bke_version}-${local.buildtime}"
  source_image_name   = "config-agent-jammy"
  ssh_username        = "ubuntu"
  floating_ip_network = "common_provider"
  reuse_ips           = true
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


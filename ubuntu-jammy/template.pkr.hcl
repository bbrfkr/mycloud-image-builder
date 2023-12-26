locals { 
  buildtime = formatdate("YYYYMMDD-hhmm", timestamp())
}

source "openstack" "ubuntu-jammy" {
  flavor              = "g1.medium"
  image_name          = "ubuntu-jammy-${local.buildtime}"
  source_image_name   = "ubuntu-jammy"
  ssh_username        = "ubuntu"
  floating_ip_network = "common_provider"
  reuse_ips           = true
  security_groups     = ["allow-all"]
}

build {
  sources = ["source.openstack.ubuntu-jammy"]
  provisioner "shell" {
    inline = [
      <<EOS
cat <<SCRIPT | sudo bash -
export DEBIAN_FRONTEND=noninteractive

# os update
apt -y update
apt -y upgrade
SCRIPT
EOS
    ]
  }
}


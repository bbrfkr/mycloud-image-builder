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
  nvidia_driver_version = "550"
  cuda_version = "12-6"
  python_version = "3.10.6"
}

source "openstack" "ubuntu-noble-sd-webui" {
  flavor              = "p1.large"
  image_name          = "ubuntu-noble-sd-webui-${local.buildtime}"
  source_image_name   = "ubuntu-noble"
  ssh_username        = "ubuntu"
  floating_ip_network = "common_provider"
  networks            = ["e79618e1-836f-42d5-bfa8-fe90e4987213"] # stg-network
  security_groups     = ["allow-all"]
}

build {
  sources = ["source.openstack.ubuntu-noble-sd-webui"]
  provisioner "file" {
    source = "./scripts"
    destination = "/tmp"
  }
  provisioner "shell" {
    inline = ["sudo -E bash /tmp/scripts/01-os.sh"]
  }
  provisioner "shell" {
    environment_vars = [
      "PYTHON_VERSION=${local.python_version}",
    ]
    inline = ["bash /tmp/scripts/02-python.sh"]
  }
  provisioner "shell" {
    environment_vars = [
      "NVIDIA_DRIVER_VERSION=${local.nvidia_driver_version}",
      "CUDA_VERSION=${local.cuda_version}",
    ]
    inline = ["bash /tmp/scripts/03-nvidia.sh"]
  }
  provisioner "shell" {
    inline = ["sudo -E bash /tmp/scripts/99-cleanup.sh"]
  }
}


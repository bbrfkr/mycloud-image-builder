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
  nvidia_driver_version = "575"
  cuda_version = "12-9"
}

source "openstack" "ubuntu-noble-comfyui" {
  flavor              = "p1.large"
  image_name          = "ubuntu-noble-comfyui-${local.buildtime}"
  source_image_name   = "ubuntu-noble"
  ssh_username        = "ubuntu"
  floating_ip_network = "common_provider"
  networks            = ["e79618e1-836f-42d5-bfa8-fe90e4987213"] # stg-network
  security_groups     = ["allow-all"]
}

build {
  sources = ["source.openstack.ubuntu-noble-comfyui"]
  provisioner "file" {
    source = "./scripts"
    destination = "/tmp"
  }
  provisioner "shell" {
    inline = ["sudo -E bash /tmp/scripts/01-os.sh"]
  }
  provisioner "shell" {
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
    inline = ["bash /tmp/scripts/04-comfyui.sh"]
    environment_vars = [
      "CUDA_VERSION=${local.cuda_version}",
    ]
  }
  provisioner "shell" {
    inline = ["sudo -E bash /tmp/scripts/99-cleanup.sh"]
  }
}


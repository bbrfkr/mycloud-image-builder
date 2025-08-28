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
  comfyui_install_script = "01-comfyui-cuda-12-9.sh"
}

source "openstack" "ubuntu-noble-comfyui" {
  flavor              = "p2.build"
  image_name          = "ubuntu-noble-comfyui-nvidia-580-cuda-12-9-${local.buildtime}"
  source_image_name   = "ubuntu-noble-gpu-nvidia-580-cuda-12-9-20250824-1317"
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
    inline = ["bash /tmp/scripts/${local.comfyui_install_script}"]
  }
  provisioner "shell" {
    inline = ["sudo -E bash /tmp/scripts/99-cleanup.sh"]
  }
}


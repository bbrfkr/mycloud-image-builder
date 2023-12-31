locals { 
  buildtime = formatdate("YYYYMMDD-hhmm", timestamp())
  nvidia_driver_version = "535"
  cuda_repo_url = "https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda-repo-ubuntu2204-12-2-local_12.2.2-535.104.05-1_amd64.deb"
}

source "openstack" "ubuntu-jammy-gpu" {
  flavor              = "p1.large"
  image_name          = "ubuntu-jammy-gpu-${local.buildtime}"
  source_image_name   = "ubuntu-jammy"
  ssh_username        = "ubuntu"
  floating_ip_network = "common_provider"
  reuse_ips           = true
  security_groups     = ["allow-all"]
}

build {
  sources = ["source.openstack.ubuntu-jammy-gpu"]
  provisioner "file" {
    source = "./scripts"
    destination = "/tmp"
  }
  provisioner "shell" {
    environment_vars = [
      "NVIDIA_DRIVER_VERSION=${local.nvidia_driver_version}",
      "CUDA_REPO_URL=${local.cuda_repo_url}",
    ]
    inline = ["sudo -E bash /tmp/scripts/main.sh"]
  }
}


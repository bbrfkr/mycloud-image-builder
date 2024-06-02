locals { 
  buildtime = formatdate("YYYYMMDD-hhmm", timestamp())
  nvidia_driver_version = "550"
  cuda_version = "12-1"
  python_version = "3.11.9"
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
    inline = ["sudo -E bash /tmp/scripts/04-docker.sh"]
  }
  provisioner "shell" {
    inline = ["sudo -E bash /tmp/scripts/99-cleanup.sh"]
  }
}


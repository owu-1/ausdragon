#!/bin/bash

# Disk space: Less than 8GB, around 3GB
# AMI: ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-20240301

NVIDIA_DRIVER_VERSION="550.54.14"

# Install NVIDIA driver
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/install-nvidia-driver.html#nvidia-installation-options
sudo apt-get update
sudo apt-get install -y gcc make
curl -fsSL -o ./nvidia_driver.run \
  "https://us.download.nvidia.com/tesla/${NVIDIA_DRIVER_VERSION}/NVIDIA-Linux-aarch64-${NVIDIA_DRIVER_VERSION}.run"
sudo sh ./nvidia_driver.run --silent
# Clean up
rm ./nvidia_driver.run
# gcc is required at runtime
sudo apt-get remove -y make
sudo apt-get autoremove

# Install NVIDIA Container Toolkit
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-with-apt
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -fsSL https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit

# Install Docker
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y docker-ce

# Clean up
sudo apt-get clean
sudo rm -r /var/lib/apt/lists/*

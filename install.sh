#!/bin/bash

# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y curl git ffmpeg python3 python3-pip build-essential pkg-config libc6-dev libssl-dev handbrake-cli

# Install MakeMKV
mkdir -p ~/makemkv && cd ~/makemkv
wget https://www.makemkv.com/download/makemkv-bin-1.17.6.tar.gz
wget https://www.makemkv.com/download/makemkv-oss-1.17.6.tar.gz
tar -xzf makemkv-oss-*.tar.gz && tar -xzf makemkv-bin-*.tar.gz
cd makemkv-oss-* && ./configure && make && sudo make install
cd ../makemkv-bin-* && make && sudo make install

# Install Plex Media Server
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
sudo apt update
sudo apt install -y plexmediaserver

# Install Automatic Ripping Machine (ARM)
git clone https://github.com/automatic-ripping-machine/automatic-ripping-machine.git
cd automatic-ripping-machine
sudo ./install.sh

# Configure ARM
sudo sed -i 's|raw_path =.*|raw_path = /opt/arm/raw|' /etc/arm/config.cfg
sudo sed -i 's|convert =.*|convert = true|' /etc/arm/config.cfg
sudo sed -i 's|mainfeature =.*|mainfeature = true|' /etc/arm/config.cfg
sudo sed -i 's|dest_path =.*|dest_path = /mnt/media/movies|' /etc/arm/config.cfg

# Ensure Plex scans the media directory
sudo usermod -aG video plex
sudo systemctl restart plexmediaserver

echo "Installation and configuration complete. Please reboot your system."

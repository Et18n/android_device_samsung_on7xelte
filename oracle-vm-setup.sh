#!/bin/bash
# Quick setup commands for Oracle Cloud VM
# Copy and paste this entire script into your VM terminal after SSH connection

set -e

echo "=== LineageOS Build Environment Setup ==="
echo "This will take about 15-20 minutes..."
echo

# Update system
echo "[1/8] Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install build dependencies
echo "[2/8] Installing build dependencies (this takes ~10 minutes)..."
sudo apt-get install -y \
    bc bison build-essential ccache curl flex \
    g++-multilib gcc-multilib git gnupg gperf imagemagick \
    lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool \
    libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 \
    libxml2-utils lzop pngcrush rsync schedtool squashfs-tools \
    xsltproc zip zlib1g-dev openjdk-11-jdk python3 python-is-python3 \
    screen vim htop

# Set up ccache for faster subsequent builds
echo "[3/8] Configuring ccache..."
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
ccache -M 50G
echo "export USE_CCACHE=1" >> ~/.bashrc
echo "export CCACHE_DIR=~/.ccache" >> ~/.bashrc

# Install repo tool
echo "[4/8] Installing repo tool..."
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
echo 'export PATH=~/bin:$PATH' >> ~/.bashrc
export PATH=~/bin:$PATH

# Configure git
echo "[5/8] Configuring git..."
git config --global user.name "Cloud Builder"
git config --global user.email "builder@cloud.local"

# Create workspace
echo "[6/8] Creating LineageOS workspace..."
mkdir -p ~/lineageos
cd ~/lineageos

# Initialize LineageOS repo
echo "[7/8] Initializing LineageOS repository..."
repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --depth=1

# Sync source (this is the longest step - 1-2 hours)
echo "[8/8] Syncing LineageOS source code..."
echo "This will take 1-2 hours depending on your internet speed..."
echo "You can monitor progress below:"
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune -j$(nproc)

# Clone device-specific repos
echo "Cloning device tree..."
git clone https://github.com/Et18n/android_device_samsung_on7xelte.git \
    device/samsung/on7xelte --depth=1

echo "Cloning kernel source..."
git clone --depth=1 https://github.com/exynos7870/android_kernel_samsung_exynos7870.git \
    kernel/samsung/exynos7870

echo "Cloning vendor blobs..."
git clone https://github.com/Et18n/android_vendor_samsung_on7xelte \
    vendor/samsung/on7xelte --depth=1

echo
echo "=== Setup Complete! ==="
echo
echo "To build the ROM, run these commands:"
echo "  screen -S build"
echo "  cd ~/lineageos"
echo "  source build/envsetup.sh"
echo "  lunch lineage_on7xelte-userdebug"
echo "  mka bacon -j\$(nproc)"
echo
echo "Press Ctrl+A then D to detach from screen session"
echo "Use 'screen -r build' to reattach and check progress"
echo
echo "Build will take approximately 3-4 hours on ARM VM"

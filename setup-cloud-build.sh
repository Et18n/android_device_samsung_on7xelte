#!/bin/bash
# Setup script for building LineageOS on a cloud VM
# Use this on Oracle Cloud, Google Cloud, AWS, or any Ubuntu/Debian VM with 100GB+ storage

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Cloud VM Build Setup for LineageOS 18.1 ===${NC}"
echo

# Update system
echo -e "${GREEN}Updating system packages...${NC}"
sudo apt-get update
sudo apt-get upgrade -y

# Install required packages
echo -e "${GREEN}Installing build dependencies...${NC}"
sudo apt-get install -y \
    bc bison build-essential ccache curl flex \
    g++-multilib gcc-multilib git gnupg gperf imagemagick \
    lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool \
    libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 \
    libxml2-utils lzop pngcrush rsync schedtool squashfs-tools \
    xsltproc zip zlib1g-dev openjdk-11-jdk python3 python-is-python3 \
    adb fastboot vim screen htop

# Set up ccache
echo -e "${GREEN}Configuring ccache...${NC}"
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
ccache -M 50G

# Install repo tool
echo -e "${GREEN}Installing repo tool...${NC}"
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
echo 'export PATH=~/bin:$PATH' >> ~/.bashrc
export PATH=~/bin:$PATH

# Configure git
git config --global user.name "Cloud Builder"
git config --global user.email "builder@cloud"

# Create workspace
echo -e "${GREEN}Creating build workspace...${NC}"
mkdir -p ~/lineageos
cd ~/lineageos

# Initialize LineageOS repo
echo -e "${GREEN}Initializing LineageOS repository...${NC}"
repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --depth=1

# Sync source (this takes 1-2 hours)
echo -e "${YELLOW}Syncing LineageOS source... This will take 1-2 hours${NC}"
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune -j$(nproc)

# Clone device tree
echo -e "${GREEN}Cloning device tree...${NC}"
git clone https://github.com/Et18n/android_device_samsung_on7xelte.git \
    device/samsung/on7xelte --depth=1

# Clone kernel
echo -e "${GREEN}Cloning kernel source...${NC}"
git clone --depth=1 https://github.com/exynos7870/android_kernel_samsung_exynos7870.git \
    kernel/samsung/exynos7870

# Clone vendor blobs
echo -e "${GREEN}Cloning vendor blobs...${NC}"
git clone https://github.com/Et18n/android_vendor_samsung_on7xelte \
    vendor/samsung/on7xelte --depth=1

echo
echo -e "${GREEN}=== Setup Complete! ===${NC}"
echo
echo -e "${YELLOW}To build the ROM, run:${NC}"
echo "  cd ~/lineageos"
echo "  source build/envsetup.sh"
echo "  lunch lineage_on7xelte-userdebug"
echo "  mka bacon -j\$(nproc)"
echo
echo -e "${YELLOW}Or use screen to run in background:${NC}"
echo "  screen -S build"
echo "  cd ~/lineageos && source build/envsetup.sh && lunch lineage_on7xelte-userdebug && mka bacon"
echo "  # Press Ctrl+A then D to detach"
echo "  # Use 'screen -r build' to reattach"

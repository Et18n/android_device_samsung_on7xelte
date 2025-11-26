#!/bin/bash
# Local ROM build script for Samsung Galaxy J7 Prime (on7xelte)
# This script sets up and builds LineageOS 18.1 locally

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== LineageOS 18.1 Local Build Script ===${NC}"
echo -e "${YELLOW}This will require approximately 80-100GB of disk space${NC}"
echo

# Check available disk space
AVAILABLE_SPACE=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
echo -e "Available disk space: ${AVAILABLE_SPACE}GB"
if [ "$AVAILABLE_SPACE" -lt 80 ]; then
    echo -e "${RED}ERROR: Insufficient disk space. Need at least 80GB free.${NC}"
    exit 1
fi

# Set up ccache to speed up subsequent builds
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
ccache -M 50G

# Install repo tool if not already installed
if [ ! -f ~/bin/repo ]; then
    echo -e "${GREEN}Installing repo tool...${NC}"
    mkdir -p ~/bin
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod a+x ~/bin/repo
fi

export PATH=~/bin:$PATH

# Configure git
git config --global user.name "Ethan"
git config --global user.email "ethan@local"

# Initialize repo if not already done
if [ ! -d .repo ]; then
    echo -e "${GREEN}Initializing LineageOS repository...${NC}"
    repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --depth=1
fi

# Sync source (this takes a while)
echo -e "${GREEN}Syncing LineageOS source code...${NC}"
echo -e "${YELLOW}This will take 1-2 hours depending on your internet speed${NC}"
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune -j$(nproc)

# Clone kernel if not present
if [ ! -d kernel/samsung/exynos7870 ]; then
    echo -e "${GREEN}Cloning kernel source...${NC}"
    git clone --depth=1 https://github.com/exynos7870/android_kernel_samsung_exynos7870.git \
        kernel/samsung/exynos7870
fi

# Copy device tree
echo -e "${GREEN}Setting up device tree...${NC}"
rm -rf device/samsung/on7xelte
cp -r device/samsung/on7xelte device/samsung/on7xelte

# Copy vendor blobs
if [ ! -d vendor/samsung/on7xelte ]; then
    echo -e "${GREEN}Cloning vendor blobs...${NC}"
    git clone https://github.com/Et18n/android_vendor_samsung_on7xelte \
        vendor/samsung/on7xelte --depth=1
fi

# Set up environment
echo -e "${GREEN}Setting up build environment...${NC}"
source build/envsetup.sh
lunch lineage_on7xelte-userdebug

# Build ROM
echo -e "${GREEN}Starting ROM build...${NC}"
echo -e "${YELLOW}This will take 4-6 hours depending on your CPU${NC}"
mka bacon -j$(nproc)

# Show build result
if [ -f out/target/product/on7xelte/lineage-*.zip ]; then
    echo -e "${GREEN}=== Build completed successfully! ===${NC}"
    echo -e "ROM package: $(ls out/target/product/on7xelte/lineage-*.zip)"
    echo -e "Recovery image: out/target/product/on7xelte/recovery.img"
    echo
    echo -e "${YELLOW}To install:${NC}"
    echo "1. Boot your device into TWRP recovery"
    echo "2. Wipe: System, Data, Cache, Dalvik"
    echo "3. Flash: $(ls out/target/product/on7xelte/lineage-*.zip)"
    echo "4. Reboot"
else
    echo -e "${RED}Build failed. Check error.log for details${NC}"
    exit 1
fi

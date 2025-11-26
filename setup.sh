#!/bin/bash

# Setup script for Samsung Galaxy J7 Prime ROM development
# This script helps set up the complete build environment

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ANDROID_ROOT=$(pwd)
DEVICE="on7xelte"
VENDOR="samsung"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Galaxy J7 Prime Build Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo -e "${RED}Error: This script must be run on Linux${NC}"
    exit 1
fi

# Install dependencies
install_dependencies() {
    echo -e "${YELLOW}Installing build dependencies...${NC}"
    
    if command -v pacman &> /dev/null; then
        # Arch Linux
        echo "Installing packages for Arch Linux..."
        
        # Core packages (less likely to conflict)
        CORE_PKGS="base-devel git curl wget python python-pip ccache rsync zip unzip"
        
        # Build tools
        BUILD_PKGS="bc bison flex gnupg gperf lz4 lzop pngcrush schedtool squashfs-tools xz"
        
        # Libraries
        LIB_PKGS="ncurses openssl zlib"
        
        # 32-bit support
        LIB32_PKGS="lib32-ncurses lib32-readline lib32-zlib"
        
        # Java and Android tools
        JAVA_PKGS="jdk11-openjdk android-tools"
        
        # Install packages in groups, skip on error
        for pkg_group in "$CORE_PKGS" "$BUILD_PKGS" "$LIB_PKGS" "$LIB32_PKGS" "$JAVA_PKGS"; do
            sudo pacman -S --needed --noconfirm $pkg_group 2>/dev/null || {
                echo -e "${YELLOW}Warning: Some packages in group couldn't be installed, continuing...${NC}"
            }
        done
        
        # Try optional packages individually
        OPTIONAL_PKGS="imagemagick libxml2"
        for pkg in $OPTIONAL_PKGS; do
            sudo pacman -S --needed --noconfirm $pkg 2>/dev/null || {
                echo -e "${YELLOW}Warning: Skipping $pkg (optional)${NC}"
            }
        done
        
        # Enable multilib repository if not enabled
        if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
            echo -e "${YELLOW}Enabling multilib repository...${NC}"
            sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
            sudo pacman -Sy --noconfirm
        fi
        
        echo -e "${GREEN}✓${NC} Core dependencies installed"
        
    elif command -v apt-get &> /dev/null; then
        # Debian/Ubuntu
        sudo apt-get update
        sudo apt-get install -y \
            bc bison build-essential ccache curl flex g++-multilib \
            gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev \
            lib32readline-dev lib32z1-dev liblz4-tool libncurses5 \
            libncurses5-dev libsdl1.2-dev libssl-dev libxml2 \
            libxml2-utils lzop pngcrush rsync schedtool squashfs-tools \
            xsltproc zip zlib1g-dev openjdk-11-jdk python3 python-is-python3 \
            adb fastboot
        echo -e "${GREEN}✓${NC} Dependencies installed"
        
    else
        echo -e "${RED}Error: Unsupported package manager${NC}"
        echo "Please install dependencies manually for your distribution"
        exit 1
    fi
}

# Configure git
configure_git() {
    echo -e "${YELLOW}Configuring git...${NC}"
    
    if [ -z "$(git config --global user.name)" ]; then
        echo "Enter your name for git:"
        read git_name
        git config --global user.name "$git_name"
    fi
    
    if [ -z "$(git config --global user.email)" ]; then
        echo "Enter your email for git:"
        read git_email
        git config --global user.email "$git_email"
    fi
    
    git config --global color.ui true
    echo -e "${GREEN}✓${NC} Git configured"
}

# Install repo tool
install_repo() {
    echo -e "${YELLOW}Installing repo tool...${NC}"
    
    if command -v repo &> /dev/null; then
        echo -e "${GREEN}✓${NC} repo already installed"
        return
    fi
    
    mkdir -p ~/bin
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod a+x ~/bin/repo
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
        export PATH="$HOME/bin:$PATH"
    fi
    
    echo -e "${GREEN}✓${NC} repo tool installed"
}

# Initialize repo
init_repo() {
    echo -e "${YELLOW}Initializing LineageOS source...${NC}"
    echo "This will download ~80GB of source code"
    read -p "Continue? (y/N) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping source initialization"
        return
    fi
    
    repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --git-lfs
    echo -e "${GREEN}✓${NC} Repo initialized"
    
    echo -e "${YELLOW}Syncing source code (this will take several hours)...${NC}"
    repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
    echo -e "${GREEN}✓${NC} Source code synced"
}

# Setup ccache
setup_ccache() {
    echo -e "${YELLOW}Setting up ccache...${NC}"
    
    export USE_CCACHE=1
    export CCACHE_EXEC=/usr/bin/ccache
    ccache -M 50G
    
    # Add to bashrc
    if ! grep -q "USE_CCACHE" ~/.bashrc; then
        echo 'export USE_CCACHE=1' >> ~/.bashrc
        echo 'export CCACHE_EXEC=/usr/bin/ccache' >> ~/.bashrc
    fi
    
    echo -e "${GREEN}✓${NC} ccache configured (50GB)"
}

# Clone device tree
clone_device_tree() {
    echo -e "${YELLOW}Setting up device tree...${NC}"
    
    if [ -d "device/$VENDOR/$DEVICE" ]; then
        echo -e "${GREEN}✓${NC} Device tree already exists"
        return
    fi
    
    echo "The device tree is already in this directory"
    echo "No need to clone from remote"
    echo -e "${GREEN}✓${NC} Device tree ready"
}

# Setup kernel
setup_kernel() {
    echo -e "${YELLOW}Setting up kernel source...${NC}"
    
    if [ -d "kernel/$VENDOR/exynos7870" ]; then
        echo -e "${GREEN}✓${NC} Kernel source already exists"
        return
    fi
    
    echo "You need to provide the kernel source"
    echo "Either:"
    echo "  1. Clone from Samsung opensource (GPL)"
    echo "  2. Use an existing kernel tree"
    echo ""
    read -p "Do you want to download from Samsung opensource? (y/N) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p kernel/$VENDOR/exynos7870
        echo "Please download the kernel from:"
        echo "https://opensource.samsung.com/"
        echo "Search for: SM-G610F"
        echo "Extract to: kernel/$VENDOR/exynos7870/"
        read -p "Press enter when ready..."
    fi
    
    echo -e "${GREEN}✓${NC} Kernel setup complete"
}

# Extract vendor blobs
extract_blobs() {
    echo -e "${YELLOW}Extracting vendor blobs...${NC}"
    
    if [ ! -f "device/$VENDOR/$DEVICE/extract-files.sh" ]; then
        echo -e "${RED}Error: extract-files.sh not found${NC}"
        return
    fi
    
    echo "Make sure your device is connected via ADB"
    read -p "Continue with extraction? (y/N) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd device/$VENDOR/$DEVICE
        chmod +x extract-files.sh
        ./extract-files.sh
        cd "$ANDROID_ROOT"
        echo -e "${GREEN}✓${NC} Vendor blobs extracted"
    else
        echo "Skipping blob extraction"
    fi
}

# Make scripts executable
make_executable() {
    echo -e "${YELLOW}Making scripts executable...${NC}"
    
    chmod +x build.sh
    chmod +x device/$VENDOR/$DEVICE/*.sh 2>/dev/null || true
    
    echo -e "${GREEN}✓${NC} Scripts are executable"
}

# Print final instructions
print_instructions() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Setup Complete!${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo -e "${GREEN}Next steps:${NC}"
    echo ""
    echo "1. Extract vendor blobs (if not done):"
    echo "   cd device/$VENDOR/$DEVICE"
    echo "   ./extract-files.sh"
    echo ""
    echo "2. Build the ROM:"
    echo "   ./build.sh"
    echo ""
    echo "Or manually:"
    echo "   source build/envsetup.sh"
    echo "   lunch lineage_$DEVICE-userdebug"
    echo "   mka bacon -j\$(nproc)"
    echo ""
    echo -e "${YELLOW}Build time: 2-6 hours (depending on hardware)${NC}"
    echo ""
}

# Main execution
main() {
    echo "This script will set up your build environment for Galaxy J7 Prime ROM development"
    echo ""
    read -p "Continue? (y/N) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
    
    install_dependencies
    configure_git
    install_repo
    setup_ccache
    
    read -p "Initialize LineageOS source? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        init_repo
    fi
    
    clone_device_tree
    setup_kernel
    make_executable
    
    read -p "Extract vendor blobs now? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        extract_blobs
    fi
    
    print_instructions
}

# Run main function
main

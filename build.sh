#!/bin/bash

# Samsung Galaxy J7 Prime (on7xelte) ROM Build Script
# This script automates the build process for custom ROMs

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DEVICE="on7xelte"
VENDOR="samsung"
ROM_NAME="lineage"
BRANCH="lineage-18.1"
BUILD_TYPE="userdebug"  # Options: user, userdebug, eng

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Galaxy J7 Prime ROM Build Script${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Function to check if we're in the right directory
check_directory() {
    if [ ! -d "device/$VENDOR/$DEVICE" ]; then
        echo -e "${RED}Error: Device tree not found!${NC}"
        echo "Please run this script from the root of your Android source tree"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} Device tree found"
}

# Function to check for required tools
check_tools() {
    echo -e "${YELLOW}Checking required tools...${NC}"
    
    tools=("repo" "python3" "make" "gcc" "git")
    for tool in "${tools[@]}"; do
        if ! command -v $tool &> /dev/null; then
            echo -e "${RED}Error: $tool is not installed${NC}"
            exit 1
        fi
    done
    echo -e "${GREEN}✓${NC} All required tools are installed"
}

# Function to check disk space
check_disk_space() {
    echo -e "${YELLOW}Checking available disk space...${NC}"
    
    available=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
    required=250
    
    if [ "$available" -lt "$required" ]; then
        echo -e "${RED}Warning: Low disk space! Available: ${available}GB, Required: ${required}GB${NC}"
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        echo -e "${GREEN}✓${NC} Sufficient disk space available (${available}GB)"
    fi
}

# Function to setup ccache
setup_ccache() {
    echo -e "${YELLOW}Setting up ccache...${NC}"
    
    export USE_CCACHE=1
    export CCACHE_EXEC=/usr/bin/ccache
    
    if [ ! -d "$HOME/.ccache" ]; then
        ccache -M 50G
        echo -e "${GREEN}✓${NC} ccache configured with 50GB"
    else
        echo -e "${GREEN}✓${NC} ccache already configured"
    fi
}

# Function to clean build
clean_build() {
    echo -e "${YELLOW}Cleaning previous build...${NC}"
    make clean
    make clobber
    echo -e "${GREEN}✓${NC} Build directory cleaned"
}

# Function to sync source
sync_source() {
    echo -e "${YELLOW}Syncing source code...${NC}"
    repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
    echo -e "${GREEN}✓${NC} Source sync complete"
}

# Main build function
build_rom() {
    echo -e "${YELLOW}Starting build process...${NC}"
    echo ""
    
    # Setup environment
    echo "Setting up build environment..."
    source build/envsetup.sh
    
    # Lunch command
    echo "Selecting device configuration..."
    lunch ${ROM_NAME}_${DEVICE}-${BUILD_TYPE}
    
    # Start build
    echo -e "${GREEN}Building ROM for $DEVICE...${NC}"
    echo "This may take several hours depending on your hardware"
    echo ""
    
    start_time=$(date +%s)
    
    # Build with progress
    mka bacon -j$(nproc) 2>&1 | tee build.log
    
    end_time=$(date +%s)
    elapsed=$((end_time - start_time))
    
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  Build Complete!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo -e "Build time: $(($elapsed / 3600))h $(($elapsed % 3600 / 60))m $(($elapsed % 60))s"
    echo ""
    
    # Find and display output location
    OUTPUT_DIR="out/target/product/$DEVICE"
    if [ -d "$OUTPUT_DIR" ]; then
        ROM_FILE=$(find "$OUTPUT_DIR" -name "*.zip" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)
        if [ -f "$ROM_FILE" ]; then
            SIZE=$(du -h "$ROM_FILE" | cut -f1)
            echo -e "${GREEN}ROM Location:${NC} $ROM_FILE"
            echo -e "${GREEN}ROM Size:${NC} $SIZE"
            echo ""
            
            # Calculate MD5
            echo -e "${YELLOW}Calculating MD5 checksum...${NC}"
            MD5=$(md5sum "$ROM_FILE" | cut -d' ' -f1)
            echo -e "${GREEN}MD5:${NC} $MD5"
        fi
    fi
}

# Parse command line arguments
CLEAN=false
SYNC=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --clean)
            CLEAN=true
            shift
            ;;
        --sync)
            SYNC=true
            shift
            ;;
        --build-type)
            BUILD_TYPE="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --clean        Clean build directories before building"
            echo "  --sync         Sync source code before building"
            echo "  --build-type   Set build type (user/userdebug/eng)"
            echo "  --help         Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Main execution
echo ""
check_directory
check_tools
check_disk_space
setup_ccache

if [ "$SYNC" = true ]; then
    sync_source
fi

if [ "$CLEAN" = true ]; then
    clean_build
fi

build_rom

echo ""
echo -e "${GREEN}All done! Flash the ROM using TWRP recovery${NC}"
echo ""

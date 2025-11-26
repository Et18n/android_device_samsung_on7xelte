#!/bin/bash
# Quick setup script for GitHub Actions ROM building

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}GitHub Actions ROM Setup${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

# Get GitHub username
echo -e "${YELLOW}Enter your GitHub username:${NC}"
read GITHUB_USER

if [ -z "$GITHUB_USER" ]; then
    echo -e "${RED}Error: GitHub username required${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Setting up repositories for: $GITHUB_USER${NC}"
echo ""

# Update workflow file
echo -e "${YELLOW}Updating GitHub Actions workflow...${NC}"
sed -i "s/YOUR_USERNAME/$GITHUB_USER/g" .github/workflows/build-rom.yml
echo -e "${GREEN}✓${NC} Workflow updated"

# Create .gitignore
echo -e "${YELLOW}Creating .gitignore...${NC}"
cat > .gitignore << 'EOF'
*.pyc
*.swp
*.swo
*~
.DS_Store
out/
.repo/
*.log
EOF
echo -e "${GREEN}✓${NC} .gitignore created"

# Initialize git repos
echo ""
echo -e "${YELLOW}Initializing Git repositories...${NC}"
echo ""

# Device tree
cd /home/Ethan/Desktop/Programming/os
if [ ! -d ".git" ]; then
    git init
    git add device/samsung/on7xelte
    git add vendor/samsung/on7xelte
    git add .github/
    git add *.md
    git add *.sh
    git add .gitignore
    git commit -m "Initial device tree for Samsung Galaxy J7 Prime (on7xelte)"
    echo -e "${GREEN}✓${NC} Device tree committed"
else
    echo -e "${YELLOW}⚠${NC}  Git already initialized in main directory"
fi

# Kernel
if [ -d "kernel/samsung/exynos7870" ]; then
    cd kernel/samsung/exynos7870
    if [ ! -d ".git" ]; then
        git init
        git add .
        git commit -m "Initial kernel for Samsung Exynos 7870"
        echo -e "${GREEN}✓${NC} Kernel committed"
    else
        echo -e "${YELLOW}⚠${NC}  Git already initialized in kernel directory"
    fi
else
    echo -e "${YELLOW}⚠${NC}  Kernel directory not found - you'll need to add it manually"
fi

# Vendor
if [ -d "vendor/samsung/on7xelte" ]; then
    cd /home/Ethan/Desktop/Programming/os/vendor/samsung/on7xelte
    if [ ! -d ".git" ]; then
        git init
        git add .
        git commit -m "Initial vendor blobs for Samsung Galaxy J7 Prime (on7xelte)"
        echo -e "${GREEN}✓${NC} Vendor blobs committed"
    else
        echo -e "${YELLOW}⚠${NC}  Git already initialized in vendor directory"
    fi
else
    echo -e "${YELLOW}⚠${NC}  Vendor directory not found - extract blobs first!"
fi

cd /home/Ethan/Desktop/Programming/os

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo ""
echo "1. Create GitHub repositories:"
echo "   - https://github.com/new"
echo "   - Name: android_device_samsung_on7xelte"
echo "   - Name: android_kernel_samsung_exynos7870"
echo "   - Name: android_vendor_samsung_on7xelte"
echo ""
echo "2. Add remotes and push:"
echo ""
echo "   ${GREEN}# Device tree${NC}"
echo "   git remote add origin https://github.com/$GITHUB_USER/android_device_samsung_on7xelte.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "   ${GREEN}# Kernel${NC}"
echo "   cd kernel/samsung/exynos7870"
echo "   git remote add origin https://github.com/$GITHUB_USER/android_kernel_samsung_exynos7870.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "   ${GREEN}# Vendor${NC}"
echo "   cd vendor/samsung/on7xelte"
echo "   git remote add origin https://github.com/$GITHUB_USER/android_vendor_samsung_on7xelte.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3. GitHub Actions will automatically build when you push!"
echo ""
echo -e "${YELLOW}Don't forget to extract vendor blobs first:${NC}"
echo "   cd device/samsung/on7xelte"
echo "   ./extract-files.sh"
echo ""

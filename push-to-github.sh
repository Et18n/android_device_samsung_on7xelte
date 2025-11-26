#!/bin/bash
# Quick push script - pushes all 3 repos to GitHub

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  Push to GitHub${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# Get GitHub username
echo -e "${YELLOW}Enter your GitHub username:${NC}"
read GITHUB_USER

if [ -z "$GITHUB_USER" ]; then
    echo -e "${RED}Error: GitHub username required${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}GitHub username: $GITHUB_USER${NC}"
echo ""
echo -e "${YELLOW}Make sure you've created these 3 repositories on GitHub:${NC}"
echo "  1. android_device_samsung_on7xelte"
echo "  2. android_kernel_samsung_exynos7870"
echo "  3. android_vendor_samsung_on7xelte"
echo ""
read -p "Have you created all 3 repos? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}Please create the repos first at:${NC}"
    echo "https://github.com/new"
    exit 0
fi

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  Pushing Repositories${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

# Push device tree
echo -e "${YELLOW}1/3 Pushing device tree...${NC}"
cd /home/Ethan/Desktop/Programming/os

if git remote | grep -q "origin"; then
    echo "Remote 'origin' already exists, removing..."
    git remote remove origin
fi

git remote add origin "https://github.com/$GITHUB_USER/android_device_samsung_on7xelte.git"
git branch -M main

echo "Pushing to GitHub..."
if git push -u origin main; then
    echo -e "${GREEN}✓${NC} Device tree pushed successfully!"
else
    echo -e "${RED}✗${NC} Failed to push device tree"
    echo "You may need to authenticate with GitHub"
    exit 1
fi

# Push kernel
echo ""
echo -e "${YELLOW}2/3 Pushing kernel...${NC}"
cd /home/Ethan/Desktop/Programming/os/kernel/samsung/exynos7870

if git remote | grep -q "origin"; then
    echo "Remote 'origin' already exists, removing..."
    git remote remove origin
fi

git remote add origin "https://github.com/$GITHUB_USER/android_kernel_samsung_exynos7870.git"
git branch -M main

echo "Pushing to GitHub..."
if git push -u origin main; then
    echo -e "${GREEN}✓${NC} Kernel pushed successfully!"
else
    echo -e "${RED}✗${NC} Failed to push kernel"
    exit 1
fi

# Push vendor
echo ""
echo -e "${YELLOW}3/3 Pushing vendor...${NC}"
cd /home/Ethan/Desktop/Programming/os/vendor/samsung/on7xelte

if git remote | grep -q "origin"; then
    echo "Remote 'origin' already exists, removing..."
    git remote remove origin
fi

git remote add origin "https://github.com/$GITHUB_USER/android_vendor_samsung_on7xelte.git"
git branch -M main

echo "Pushing to GitHub..."
if git push -u origin main; then
    echo -e "${GREEN}✓${NC} Vendor pushed successfully!"
else
    echo -e "${RED}✗${NC} Failed to push vendor"
    exit 1
fi

cd /home/Ethan/Desktop/Programming/os

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  All Repositories Pushed!${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo ""
echo "1. Update GitHub Actions workflow:"
echo "   Go to: https://github.com/$GITHUB_USER/android_device_samsung_on7xelte"
echo "   Edit: .github/workflows/build-rom.yml"
echo "   Replace 'YOUR_USERNAME' with '$GITHUB_USER' (2 places)"
echo ""
echo "2. Trigger build:"
echo "   Go to: https://github.com/$GITHUB_USER/android_device_samsung_on7xelte/actions"
echo "   Click: 'Build LineageOS for Galaxy J7 Prime'"
echo "   Click: 'Run workflow'"
echo ""
echo "3. Wait for build to complete (~5-6 hours)"
echo ""
echo "4. Download ROM from Artifacts section"
echo ""
echo -e "${GREEN}Happy building! 🚀${NC}"
echo ""

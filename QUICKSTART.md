# Quick Start Guide - Building ROM for Galaxy J7 Prime

## Prerequisites Check

Before starting, ensure you have:

- [ ] Linux system (Ubuntu 20.04+ recommended)
- [ ] 250+ GB free disk space
- [ ] 16+ GB RAM
- [ ] Stable internet connection
- [ ] 8+ hours for initial setup and first build

## Quick Setup (30 minutes)

```bash
# 1. Navigate to the project directory
cd /home/Ethan/Desktop/Programming/os

# 2. Run the automated setup script
./setup.sh

# This script will:
# - Install all required dependencies
# - Configure git
# - Install repo tool
# - Setup ccache
# - Initialize LineageOS source (optional)
# - Guide you through kernel and vendor setup
```

## Building Your First ROM (2-6 hours)

```bash
# Method 1: Automated build (recommended)
./build.sh

# Method 2: Manual build
source build/envsetup.sh
lunch lineage_on7xelte-userdebug
mka bacon -j$(nproc)
```

## Installing on Device

### Requirements:

1. **Unlocked bootloader**
2. **TWRP Recovery** installed
3. **Backup** your data first!

### Installation Steps:

```bash
# 1. Boot to TWRP (Power + Volume Up + Home)

# 2. Wipe (first time installation)
#    - Wipe > Advanced Wipe
#    - Select: Dalvik, Cache, Data, System
#    - Swipe to Wipe

# 3. Install ROM
#    - Install > select lineage-*.zip
#    - Swipe to confirm

# 4. Install GApps (optional)
#    - Install > select gapps-*.zip
#    - Swipe to confirm

# 5. Reboot System
#    - First boot takes 10-15 minutes
```

## Extracting Vendor Blobs

Before building, you must extract proprietary files from your device:

```bash
# 1. Enable USB Debugging on your device
# Settings > About Phone > tap "Build Number" 7 times
# Settings > Developer Options > Enable "USB Debugging"

# 2. Connect device via USB

# 3. Extract files
cd device/samsung/on7xelte
./extract-files.sh

# The script will automatically pull files from your device
```

## Build Options

```bash
# Clean build (removes previous build)
./build.sh --clean

# Sync source before building
./build.sh --sync

# Engineering build (more debugging)
./build.sh --build-type eng

# User build (release)
./build.sh --build-type user
```

## Troubleshooting

### Build Fails with "Out of Memory"

```bash
# Reduce parallel jobs
mka bacon -j4  # instead of -j$(nproc)
```

### "repo command not found"

```bash
# Add to PATH
export PATH="$HOME/bin:$PATH"
source ~/.bashrc
```

### Vendor blobs extraction fails

```bash
# Manual extraction from system dump
# 1. Get stock ROM
# 2. Extract system.img
# 3. Mount and copy files manually
```

### Build succeeds but ROM doesn't boot

```bash
# Check kernel configuration
# Verify partition sizes in BoardConfig.mk
# Check SELinux policies
# Review build logs in build.log
```

## Project Structure

```
os/
├── device/samsung/on7xelte/     # Device-specific configs
├── vendor/samsung/on7xelte/     # Proprietary blobs
├── kernel/samsung/exynos7870/   # Kernel source
├── build.sh                     # Automated build script
├── setup.sh                     # Setup script
└── README.md                    # Full documentation
```

## Useful Commands

```bash
# Check build progress
tail -f build.log

# Clean specific module
make clean-<module-name>

# Rebuild only system
mka systemimage

# Rebuild only boot
mka bootimage

# Check build variables
printconfig

# Show lunch menu
lunch
```

## Performance Tips

1. **Use SSD** for source code storage
2. **Enable ccache** (already done by setup script)
3. **Use faster internet** for initial sync
4. **More RAM = faster builds**
5. **Close unnecessary programs** during build

## Community Resources

- **XDA Forums**: https://forum.xda-developers.com/
- **LineageOS Wiki**: https://wiki.lineageos.org/
- **Telegram Groups**: Search for "Galaxy J7 Prime development"
- **GitHub Issues**: Report bugs in device tree repo

## Daily Development Workflow

```bash
# 1. Sync latest changes
repo sync -c -j$(nproc --all)

# 2. Make your changes to device tree

# 3. Test build
./build.sh

# 4. Test on device

# 5. Commit changes
git add .
git commit -m "Description of changes"
git push
```

## Need Help?

1. Check build.log for errors
2. Search XDA forums for similar issues
3. Ask in LineageOS community channels
4. Open GitHub issue with full error log

---

**Remember**: Building custom ROMs requires patience. Your first build will take the longest. Subsequent builds are much faster thanks to ccache!

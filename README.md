# Samsung Galaxy J7 Prime (on7xelte) Custom ROM

This repository contains the device tree for building custom Android ROMs (LineageOS) for the Samsung Galaxy J7 Prime (SM-G610F, codename: on7xelte).

## Device Specifications

| Component       | Details                                   |
| :-------------- | :---------------------------------------- |
| CPU             | Octa-core 1.6 GHz Cortex-A53              |
| Chipset         | Samsung Exynos 7870                       |
| GPU             | Mali-T830 MP1                             |
| Memory          | 3 GB RAM                                  |
| Shipped Android | 6.0.1 (upgradeable to 8.1.0)              |
| Storage         | 16/32 GB                                  |
| MicroSD         | Up to 256 GB                              |
| Battery         | Non-removable Li-Ion 3300 mAh             |
| Display         | 5.5 inches, 1080 x 1920 pixels (~401 ppi) |
| Rear Camera     | 13 MP, f/1.9, autofocus, LED flash        |
| Front Camera    | 8 MP, f/1.9                               |

## Building

### Prerequisites

1. **Build Environment**: Ubuntu 20.04 or higher (recommended) or any compatible Linux distribution
2. **Disk Space**: At least 250 GB of free space
3. **RAM**: 16 GB minimum (32 GB recommended)
4. **Build Tools**: Installed as per LineageOS wiki

### Setting up the build environment

```bash
# Install build dependencies

# For Arch Linux:
sudo pacman -Syu --needed base-devel bc bison ccache curl flex git gnupg \
  gperf imagemagick lib32-ncurses lib32-readline lib32-zlib lz4 ncurses \
  openssl libxml2 lzop pngcrush rsync schedtool squashfs-tools xz zip zlib \
  jdk11-openjdk python python-pip android-tools wget multilib-devel

# For Ubuntu/Debian:
sudo apt-get install bc bison build-essential ccache curl flex g++-multilib \
  gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev \
  lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev \
  libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc \
  zip zlib1g-dev openjdk-11-jdk python3
```

### Initialize LineageOS Source

```bash
# Create working directory
mkdir -p ~/android/lineage
cd ~/android/lineage

# Initialize repo
repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --git-lfs

# Sync the source (this will take several hours)
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
```

### Clone device tree

```bash
# Clone this device tree
git clone https://github.com/yourusername/android_device_samsung_on7xelte.git device/samsung/on7xelte

# Clone vendor blobs (you need to extract these from your device first)
git clone https://github.com/yourusername/android_vendor_samsung_on7xelte.git vendor/samsung/on7xelte

# Clone kernel source
git clone https://github.com/yourusername/android_kernel_samsung_exynos7870.git kernel/samsung/exynos7870
```

### Extract proprietary blobs

Before building, you need to extract proprietary files from your device:

```bash
cd device/samsung/on7xelte
chmod +x extract-files.sh
./extract-files.sh
```

Make sure your device is connected via ADB with USB debugging enabled, or provide a system dump.

### Build the ROM

```bash
# Navigate to source directory
cd ~/android/lineage

# Set up build environment
source build/envsetup.sh

# Choose your device
lunch lineage_on7xelte-userdebug

# Start compilation (use -j$(nproc) for parallel building)
mka bacon -j$(nproc)
```

The build process can take 2-6 hours depending on your hardware.

### Output

After successful compilation, the ROM zip will be located at:

```
out/target/product/on7xelte/lineage-18.1-YYYYMMDD-UNOFFICIAL-on7xelte.zip
```

## Installation

### Prerequisites

- Unlocked bootloader
- TWRP Recovery installed
- Backup of all important data

### Steps

1. **Boot into TWRP Recovery**

   - Power off device
   - Hold Volume Up + Home + Power buttons

2. **Wipe data** (recommended for first install)

   - Wipe > Advanced Wipe
   - Select: Dalvik Cache, Cache, Data, System
   - Swipe to Wipe

3. **Install ROM**

   - Install > Select the ROM zip
   - Swipe to confirm flash

4. **Install GApps** (optional)

   - Install appropriate GApps package for Android 11
   - Recommended: MindTheGapps or NikGApps

5. **Reboot**
   - Reboot System
   - First boot may take 10-15 minutes

## Current Status

### Working

- [x] Boot
- [x] Display
- [x] Touch
- [x] Wi-Fi
- [x] Bluetooth
- [x] RIL (Calls, SMS, Data)
- [x] Audio
- [x] Sensors
- [x] Camera
- [x] GPS
- [x] Fingerprint
- [x] USB

### Known Issues

- [ ] VoLTE (needs further testing)
- [ ] Video recording might have issues
- [ ] SELinux is permissive (needs policy work)

## Kernel Source

The kernel for this device is based on Samsung's official GPL release for the Exynos 7870 platform.

Source: https://opensource.samsung.com/

## Contributing

Contributions are welcome! If you want to help improve device support:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Credits

- **LineageOS Team** - Base ROM
- **Samsung** - Kernel sources and firmware
- **Android Open Source Project** - Android base

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.

## Disclaimer

- **Use at your own risk!** Flashing custom ROMs can potentially brick your device
- Make backups before proceeding
- The developers are not responsible for any damage to your device
- This is an unofficial build not endorsed by LineageOS

## Support

For issues and questions:

- Open an issue on GitHub
- Join XDA Developers forums
- Visit LineageOS community channels

## Additional Resources

- [LineageOS Wiki](https://wiki.lineageos.org/)
- [XDA Developers - Galaxy J7 Prime](https://forum.xda-developers.com/c/samsung-galaxy-j7-prime.6171/)
- [Android Building Guide](https://source.android.com/setup/build/building)

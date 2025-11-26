# Galaxy J7 Prime Custom ROM - GitHub Actions Build

This repository contains the device tree for building LineageOS for the Samsung Galaxy J7 Prime (on7xelte) using GitHub Actions.

## ⚡ Automated Cloud Building

No need to download 80GB locally! GitHub Actions will build the ROM for you automatically.

## 🚀 How to Use

### 1. Fork This Repository

Click the "Fork" button at the top right of this page.

### 2. Add Kernel and Vendor Sources

You need to create two additional repositories:

#### a) Kernel Repository

```bash
# Create a new repo on GitHub named: kernel_samsung_exynos7870
# Upload Samsung's GPL kernel source there
```

#### b) Vendor Blobs Repository

```bash
# Create a new repo on GitHub named: vendor_samsung_on7xelte
# Upload extracted vendor blobs there
```

### 3. Update Workflow File

Edit `.github/workflows/build-rom.yml` and replace the placeholders:

```yaml
- name: Clone kernel source
  run: |
    git clone https://github.com/YOUR_USERNAME/kernel_samsung_exynos7870 kernel/samsung/exynos7870 --depth=1

- name: Clone vendor blobs
  run: |
    git clone https://github.com/YOUR_USERNAME/vendor_samsung_on7xelte vendor/samsung/on7xelte --depth=1
```

### 4. Trigger Build

Push to your repo or click "Actions" → "Build LineageOS" → "Run workflow"

### 5. Download ROM

After 2-6 hours, download your ROM from the "Artifacts" section of the completed workflow.

## 📋 What You Need to Prepare

### Extract Vendor Blobs

On your device:

```bash
# Enable ADB debugging
# Connect device
cd device/samsung/on7xelte
./extract-files.sh

# Commit and push to vendor_samsung_on7xelte repo
```

### Get Kernel Source

Download from Samsung:

1. Visit https://opensource.samsung.com/
2. Search for "SM-G610F"
3. Download kernel source
4. Extract and push to kernel_samsung_exynos7870 repo

## 🔧 Local Development (Optional)

You can still develop locally without building:

```bash
# Edit device tree files
cd device/samsung/on7xelte

# Modify configurations
nano BoardConfig.mk
nano device.mk
nano lineage_on7xelte.mk

# Commit and push
git add .
git commit -m "Update device configuration"
git push

# GitHub Actions will automatically build!
```

## 📂 Repository Structure

```
.
├── .github/workflows/
│   └── build-rom.yml          # Automated build configuration
├── device/samsung/on7xelte/   # Device tree (this repo)
├── kernel/samsung/exynos7870/ # Kernel source (separate repo)
└── vendor/samsung/on7xelte/   # Vendor blobs (separate repo)
```

## ⚙️ Build Configuration

- **ROM**: LineageOS 18.1 (Android 11)
- **Device**: Samsung Galaxy J7 Prime (SM-G610F)
- **Codename**: on7xelte
- **Platform**: Exynos 7870
- **Build Type**: userdebug

## 🎯 Advantages of GitHub Actions

✅ **Free builds** - Up to 2000 minutes/month
✅ **No local storage** - Builds in the cloud
✅ **Automatic** - Builds on every commit
✅ **Parallel** - Multiple builds at once
✅ **Cached** - ccache speeds up rebuilds
✅ **Artifacts** - Auto-download ROM when done

## 📝 Customization

### Change ROM Version

Edit `.github/workflows/build-rom.yml`:

```yaml
repo init -u https://github.com/LineageOS/android.git -b lineage-19.1
```

### Change Build Type

```yaml
lunch lineage_on7xelte-user # For release builds
```

### Adjust Build Resources

```yaml
mka bacon -j4 # Use fewer cores if builds fail
```

## 🐛 Troubleshooting

### Build Fails with "Out of Memory"

```yaml
# In build-rom.yml, reduce parallel jobs:
mka bacon -j2
```

### Build Fails with "Kernel not found"

- Make sure you've added the kernel repository
- Check the clone URL is correct
- Ensure kernel has proper defconfig

### Build Fails with "Vendor blobs missing"

- Make sure you've extracted vendor blobs
- Check proprietary-files.txt matches your blobs
- Verify vendor repo is accessible

## 📊 Build Status

After setting up, you'll see build status badges:

[![Build Status](https://github.com/YOUR_USERNAME/android_device_samsung_on7xelte/workflows/Build%20LineageOS/badge.svg)](https://github.com/YOUR_USERNAME/android_device_samsung_on7xelte/actions)

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repo
2. Create a feature branch
3. Make your changes
4. Test with GitHub Actions
5. Submit a pull request

## 📜 License

Apache License 2.0

## 🙏 Credits

- LineageOS Team
- Samsung (kernel GPL sources)
- AOSP Project
- XDA Developers Community

---

**Happy Building!** 🎉

Push your changes and let GitHub do the heavy lifting!

# GitHub Actions Setup Guide - Step by Step

## 📋 Prerequisites

1. A GitHub account
2. Your device (Galaxy J7 Prime) with USB debugging enabled
3. Git installed on your Arch Linux system

## 🚀 Step-by-Step Guide

### Step 1: Extract Vendor Blobs from Your Device

First, we need to get the proprietary files from your phone:

```bash
# Enable USB Debugging on your phone:
# Settings → About Phone → Tap "Build Number" 7 times
# Settings → Developer Options → Enable "USB Debugging"

# Connect your phone via USB and accept the debugging prompt

# Navigate to device tree
cd /home/Ethan/Desktop/Programming/os/device/samsung/on7xelte

# Make extraction script executable
chmod +x extract-files.sh

# Extract files from connected device
./extract-files.sh

# This will create files in: vendor/samsung/on7xelte/proprietary/
```

### Step 2: Download Kernel Source

Get the official Samsung kernel:

```bash
# Open browser and go to:
# https://opensource.samsung.com/

# Search for: "SM-G610F" or "Galaxy J7 Prime"
# Download the kernel source GPL package
# It will be named something like: "SM-G610F_NN_OPN_KK_0001.zip"

# Extract it
cd ~/Downloads
unzip SM-G610F*.zip

# Move to kernel directory
mkdir -p /home/Ethan/Desktop/Programming/os/kernel/samsung/exynos7870
cp -r Kernel/* /home/Ethan/Desktop/Programming/os/kernel/samsung/exynos7870/

# Or if you can't get it, you can use a compatible kernel from GitHub:
# git clone https://github.com/LineageOS/android_kernel_samsung_universal7870 /home/Ethan/Desktop/Programming/os/kernel/samsung/exynos7870
```

### Step 3: Create GitHub Repositories

You need to create **3 separate repositories** on GitHub:

#### A. Device Tree Repository

```bash
cd /home/Ethan/Desktop/Programming/os

# Initialize git for device tree
git init

# Create .gitignore
cat > .gitignore << 'EOF'
*.pyc
*.swp
*.swo
*~
.DS_Store
out/
.repo/
EOF

# Add device tree and workflow files
git add device/samsung/on7xelte
git add .github/
git add *.md
git add *.sh

# Commit
git commit -m "Initial device tree for Samsung Galaxy J7 Prime (on7xelte)"

# Create repo on GitHub (go to github.com/new) and name it:
# android_device_samsung_on7xelte

# Add remote and push
git remote add origin https://github.com/YOUR_USERNAME/android_device_samsung_on7xelte.git
git branch -M main
git push -u origin main
```

#### B. Vendor Blobs Repository

```bash
cd /home/Ethan/Desktop/Programming/os/vendor/samsung/on7xelte

# Initialize git
git init

# Add all vendor files
git add .

# Commit
git commit -m "Initial vendor blobs for Samsung Galaxy J7 Prime (on7xelte)"

# Create repo on GitHub and name it:
# android_vendor_samsung_on7xelte

# Add remote and push
git remote add origin https://github.com/YOUR_USERNAME/android_vendor_samsung_on7xelte.git
git branch -M main
git push -u origin main
```

#### C. Kernel Repository

```bash
cd /home/Ethan/Desktop/Programming/os/kernel/samsung/exynos7870

# Initialize git (if not already a git repo)
git init

# Add all kernel files
git add .

# Commit
git commit -m "Initial kernel for Samsung Exynos 7870"

# Create repo on GitHub and name it:
# android_kernel_samsung_exynos7870

# Add remote and push
git remote add origin https://github.com/YOUR_USERNAME/android_kernel_samsung_exynos7870.git
git branch -M main
git push -u origin main
```

### Step 4: Update GitHub Actions Workflow

Now update the workflow file with your repository URLs:

```bash
cd /home/Ethan/Desktop/Programming/os
nano .github/workflows/build-rom.yml
```

Find these lines and replace `YOUR_USERNAME` with your actual GitHub username:

```yaml
- name: Clone kernel source
  run: |
    git clone https://github.com/YOUR_USERNAME/android_kernel_samsung_exynos7870 kernel/samsung/exynos7870 --depth=1

- name: Clone vendor blobs
  run: |
    git clone https://github.com/YOUR_USERNAME/android_vendor_samsung_on7xelte vendor/samsung/on7xelte --depth=1
```

Save and commit:

```bash
git add .github/workflows/build-rom.yml
git commit -m "Update workflow with repository URLs"
git push
```

### Step 5: Enable GitHub Actions

1. Go to your device tree repository on GitHub
2. Click on **"Actions"** tab
3. If prompted, click **"I understand my workflows, go ahead and enable them"**
4. You should see **"Build LineageOS for Galaxy J7 Prime"** workflow

### Step 6: Trigger Your First Build

**Option A: Automatic (on push)**

```bash
# Any push to main branch will trigger a build
cd /home/Ethan/Desktop/Programming/os
git add .
git commit -m "Trigger first build"
git push
```

**Option B: Manual trigger**

1. Go to GitHub → Your repo → Actions tab
2. Click **"Build LineageOS for Galaxy J7 Prime"**
3. Click **"Run workflow"** button
4. Select branch: **main**
5. Click green **"Run workflow"** button

### Step 7: Monitor the Build

1. Go to **Actions** tab on GitHub
2. Click on the running workflow
3. Watch the build progress in real-time
4. Build will take **2-6 hours**

### Step 8: Download Your ROM

Once the build completes successfully:

1. Go to the completed workflow run
2. Scroll down to **"Artifacts"** section
3. Download **lineage-18.1-on7xelte-YYYYMMDD.zip**
4. File size will be ~600-800 MB

### Step 9: Flash to Your Device

```bash
# Download the ROM zip to your computer
# Boot phone into TWRP recovery:
# Power off → Hold Volume Up + Home + Power

# In TWRP:
# 1. Wipe → Advanced Wipe → Select: Dalvik, Cache, Data, System
# 2. Install → Select the ROM zip
# 3. Swipe to flash
# 4. Reboot System
# 5. First boot takes 10-15 minutes
```

## 🔍 Troubleshooting

### Build Fails: "Kernel not found"

Check that your kernel repo URL is correct:

```bash
# Test if accessible:
git ls-remote https://github.com/YOUR_USERNAME/android_kernel_samsung_exynos7870
```

### Build Fails: "Vendor blobs missing"

Make sure you extracted blobs properly:

```bash
ls -la /home/Ethan/Desktop/Programming/os/vendor/samsung/on7xelte/proprietary/
# Should show files like libsec-ril.so, etc.
```

### Build Fails: "Out of memory"

Edit `.github/workflows/build-rom.yml` and reduce parallel jobs:

```yaml
mka bacon -j2 # Instead of -j$(nproc)
```

### Build Takes Too Long (>6 hours timeout)

GitHub Actions has a 6-hour limit. If hitting it:

```yaml
# Use prebuilt kernel instead of building from source
# Or split into multiple jobs
```

## 📊 Free Tier Limits

GitHub Actions free tier:

- ✅ 2,000 minutes/month for private repos
- ✅ Unlimited for public repos
- ✅ 20 concurrent jobs

Your build uses ~3-4 hours, so you can do:

- **~10 builds/month** (private repo)
- **Unlimited builds** (public repo)

## 🎯 Quick Reference Commands

```bash
# Check build status
# Go to: https://github.com/YOUR_USERNAME/android_device_samsung_on7xelte/actions

# Trigger manual build
# GitHub → Actions → Build LineageOS → Run workflow

# Download ROM
# GitHub → Actions → Completed build → Artifacts

# Flash ROM
# Boot to TWRP → Wipe → Install ZIP → Reboot
```

## 🔄 Future Builds

After your first successful build:

```bash
# Make changes to device tree
cd /home/Ethan/Desktop/Programming/os/device/samsung/on7xelte
nano BoardConfig.mk  # or any file

# Commit and push
git add .
git commit -m "Update device configuration"
git push

# GitHub Actions automatically builds the new version!
```

## 📱 Making Your Repos Public (Recommended)

For unlimited builds:

1. Go to each repo → Settings
2. Scroll to bottom → "Danger Zone"
3. Click "Change repository visibility"
4. Choose "Make public"

Public repos get unlimited GitHub Actions minutes! 🎉

## ✅ Checklist

- [ ] USB debugging enabled on phone
- [ ] Vendor blobs extracted
- [ ] Kernel source obtained
- [ ] 3 repos created on GitHub
- [ ] All code pushed to GitHub
- [ ] Workflow file updated with your URLs
- [ ] GitHub Actions enabled
- [ ] First build triggered
- [ ] Build completed successfully
- [ ] ROM downloaded
- [ ] ROM flashed to device
- [ ] Device boots successfully

---

That's it! You're now building custom ROMs in the cloud! 🚀

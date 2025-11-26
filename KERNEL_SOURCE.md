# Getting the Kernel Source

You have several options to get the kernel source for the Samsung Galaxy J7 Prime (Exynos 7870):

## Option 1: Download from Samsung Opensource (Official)

### Step 1: Go to Samsung Opensource

Visit: https://opensource.samsung.com/

### Step 2: Search for Your Model

Search for: **"SM-G610F"** or **"Galaxy J7 Prime"**

### Step 3: Download

Look for the kernel package (usually named something like):

- `SM-G610F_NN_OPN_KK_0001.zip`
- Or similar with your region code

### Step 4: Extract

```bash
cd ~/Downloads
unzip SM-G610F*.zip

# Find the kernel folder (usually named "Kernel" or similar)
# Copy to your project:
cp -r Kernel/* /home/Ethan/Desktop/Programming/os/kernel/samsung/exynos7870/
```

## Option 2: Use LineageOS Universal7870 Kernel (Compatible)

This is a community-maintained kernel for Exynos 7870 devices:

```bash
cd /home/Ethan/Desktop/Programming/os/kernel/samsung

# Remove empty directory
rm -rf exynos7870

# Clone the kernel
git clone https://github.com/LineageOS/android_kernel_samsung_universal7870.git exynos7870

# Or for specific branch:
git clone -b lineage-18.1 https://github.com/LineageOS/android_kernel_samsung_universal7870.git exynos7870
```

## Option 3: Use Existing Device Tree Kernel

Search GitHub for existing J7 Prime kernels:

```bash
# Example (check if these exist):
git clone https://github.com/anything-official/android_kernel_samsung_j7primelte.git kernel/samsung/exynos7870

# Or search GitHub for: "exynos7870 kernel" or "j7prime kernel"
```

## After Getting Kernel

### Verify kernel structure:

```bash
cd /home/Ethan/Desktop/Programming/os/kernel/samsung/exynos7870
ls -la

# You should see:
# - Makefile
# - arch/
# - drivers/
# - kernel/
# - etc.
```

### Commit to git:

```bash
cd /home/Ethan/Desktop/Programming/os/kernel/samsung/exynos7870

# If you cloned from git, it's already set up
# If you extracted from Samsung, initialize git:
git init
git add .
git commit -m "Initial kernel source for Exynos 7870"
```

### Create defconfig (if missing):

```bash
# Check if defconfig exists:
ls arch/arm64/configs/exynos7870-on7xelte_defconfig

# If not, you may need to use a similar one:
cp arch/arm64/configs/exynos7870_defconfig arch/arm64/configs/exynos7870-on7xelte_defconfig
```

## Recommended: Option 2 (LineageOS Kernel)

For easiest setup, use the LineageOS universal7870 kernel:

```bash
cd /home/Ethan/Desktop/Programming/os/kernel/samsung
rm -rf exynos7870
git clone -b lineage-18.1 https://github.com/LineageOS/android_kernel_samsung_universal7870.git exynos7870
```

This kernel is:

- ✅ Already compatible with LineageOS 18.1
- ✅ Maintained by the community
- ✅ Tested on similar devices
- ✅ Ready to build

## After Adding Kernel

Run the GitHub setup again:

```bash
cd /home/Ethan/Desktop/Programming/os
./github-setup.sh
```

Or manually push the kernel repo:

```bash
cd kernel/samsung/exynos7870
git remote add origin https://github.com/YOUR_USERNAME/android_kernel_samsung_exynos7870.git
git branch -M main
git push -u origin main
```

## Troubleshooting

### "Kernel won't compile"

- Try using the LineageOS universal7870 kernel (Option 2)
- Check defconfig exists
- Review GitHub Actions build logs

### "Wrong kernel for device"

- The universal7870 kernel works for all Exynos 7870 devices
- J7 Prime uses the same SoC as other J7 variants

### "Kernel source too large"

- Use `--depth=1` when cloning to get shallow clone
- This reduces size from ~2GB to ~500MB

---

**Quick command to get started:**

```bash
cd /home/Ethan/Desktop/Programming/os/kernel/samsung
rm -rf exynos7870
git clone --depth=1 -b lineage-18.1 \
  https://github.com/LineageOS/android_kernel_samsung_universal7870.git \
  exynos7870
```

Then continue with the GitHub Actions setup! 🚀

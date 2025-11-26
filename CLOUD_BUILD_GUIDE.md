# Building LineageOS using Google Cloud Shell (Free)

## Quick Start Guide

1. **Open Google Cloud Shell**: https://shell.cloud.google.com
   - No credit card required
   - 5GB persistent storage (home directory)
   - Ephemeral 50GB workspace (deleted after session)

2. **Upload the setup script**:
   ```bash
   # In Cloud Shell, create the setup script
   wget https://raw.githubusercontent.com/Et18n/android_device_samsung_on7xelte/main/setup-cloud-build.sh
   chmod +x setup-cloud-build.sh
   ./setup-cloud-build.sh
   ```

3. **Build in the ephemeral storage** (more space):
   ```bash
   # Cloud Shell has limited home storage, use /tmp
   cd /tmp
   mkdir lineageos && cd lineageos
   
   # Initialize repo
   repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --depth=1
   repo sync -c --no-clone-bundle --no-tags --optimized-fetch -j$(nproc)
   
   # Clone device, kernel, vendor
   git clone https://github.com/Et18n/android_device_samsung_on7xelte device/samsung/on7xelte --depth=1
   git clone https://github.com/exynos7870/android_kernel_samsung_exynos7870 kernel/samsung/exynos7870 --depth=1
   git clone https://github.com/Et18n/android_vendor_samsung_on7xelte vendor/samsung/on7xelte --depth=1
   
   # Build
   source build/envsetup.sh
   lunch lineage_on7xelte-userdebug
   mka bacon -j$(nproc)
   ```

4. **Download the ROM**:
   - Click the "Download File" button in Cloud Shell
   - Navigate to: `/tmp/lineageos/out/target/product/on7xelte/lineage-*.zip`
   - Or use: `cloudshell download out/target/product/on7xelte/lineage-*.zip`

## Limitations:
- Session timeout after 20 minutes of inactivity (use `gcloud alpha cloud-shell ssh` from local to keep alive)
- Build takes 4-6 hours
- Need to keep browser tab open or use SSH

## Tip: Use tmux to survive disconnections:
```bash
tmux new -s build
# Run your build commands
# Press Ctrl+B then D to detach
# Reconnect: tmux attach -t build
```

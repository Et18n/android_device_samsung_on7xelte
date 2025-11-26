# Quick Start: Build LineageOS in the Cloud (Your PC stays cool!)

Since your local machine doesn't have enough RAM/CPU and would overheat, here are your **FREE** cloud options:

---

## 🏆 RECOMMENDED: Oracle Cloud Free Tier

**Pros**: Best specs, 200GB storage, no timeout, completely free forever  
**Cons**: Requires account signup, takes 10 minutes to set up

### Steps:
1. **Sign up**: https://www.oracle.com/cloud/free/
2. **Create VM**: Ubuntu 22.04, VM.Standard.A1.Flex (4 OCPUs, 24GB RAM, 200GB disk)
3. **SSH into VM**: `ssh ubuntu@<your-vm-ip>`
4. **Run setup**:
   ```bash
   wget https://raw.githubusercontent.com/Et18n/android_device_samsung_on7xelte/main/setup-cloud-build.sh
   chmod +x setup-cloud-build.sh
   ./setup-cloud-build.sh
   ```
5. **Build** (in screen session so it survives disconnection):
   ```bash
   screen -S build
   cd ~/lineageos
   source build/envsetup.sh
   lunch lineage_on7xelte-userdebug
   mka bacon -j$(nproc)
   # Press Ctrl+A then D to detach, check back in 3-4 hours
   ```
6. **Download ROM**:
   ```bash
   # From your local machine:
   scp ubuntu@<your-vm-ip>:~/lineageos/out/target/product/on7xelte/lineage-*.zip ~/Downloads/
   ```

**Build Time**: 3-4 hours with ARM processor

📖 **Full Guide**: See `ORACLE_CLOUD_SETUP.md`

---

## ⚡ QUICKEST: Google Cloud Shell

**Pros**: No signup needed if you have Google account, instant access  
**Cons**: 20min inactivity timeout, need to keep browser open

### Steps:
1. Open: https://shell.cloud.google.com
2. Run:
   ```bash
   cd /tmp
   mkdir lineageos && cd lineageos
   repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --depth=1
   repo sync -c --no-clone-bundle --no-tags -j$(nproc)
   git clone https://github.com/Et18n/android_device_samsung_on7xelte device/samsung/on7xelte --depth=1
   git clone https://github.com/exynos7870/android_kernel_samsung_exynos7870 kernel/samsung/exynos7870 --depth=1
   git clone https://github.com/Et18n/android_vendor_samsung_on7xelte vendor/samsung/on7xelte --depth=1
   source build/envsetup.sh
   lunch lineage_on7xelte-userdebug
   mka bacon
   ```
3. Keep browser tab open for 4-6 hours
4. Download: Click "Download File" → navigate to ROM zip

**Build Time**: 4-6 hours

📖 **Full Guide**: See `CLOUD_BUILD_GUIDE.md`

---

## 💰 Alternative: Paid Cloud Services

If free options fail, these are cheap:
- **DigitalOcean**: $24/month for Basic Droplet (200GB SSD, 4GB RAM)
- **Vultr**: $24/month for similar specs
- **AWS EC2**: ~$30/month for t3.medium + 200GB EBS

Cancel after build completes. Total cost: ~$1-2 for a few hours.

---

## 📱 After Building

Once you have `lineage-18.1-on7xelte-YYYYMMDD.zip`:

1. Copy to phone: `adb push lineage-*.zip /sdcard/`
2. Boot to TWRP recovery
3. **Wipe**: System, Data, Cache, Dalvik
4. **Install**: Select the lineage zip file
5. **Reboot**

---

## 🆘 Need Help?

All setup scripts are in this repository:
- `setup-cloud-build.sh` - Automated cloud VM setup
- `ORACLE_CLOUD_SETUP.md` - Detailed Oracle Cloud guide
- `CLOUD_BUILD_GUIDE.md` - Google Cloud Shell guide

Your device tree is ready at: https://github.com/Et18n/android_device_samsung_on7xelte

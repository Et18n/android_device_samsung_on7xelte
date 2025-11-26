# Oracle Cloud Free Tier - Best Free Option for ROM Building

## Why Oracle Cloud?
- **200GB boot volume** (plenty of space)
- **ARM: 4 OCPUs + 24GB RAM** or **AMD: 2 OCPUs + 12GB RAM**
- **Always Free** - no credit card expiry issues
- Can run 24/7 without timeout

## Setup Instructions

### 1. Create Oracle Cloud Account
1. Go to: https://www.oracle.com/cloud/free/
2. Sign up for "Always Free" tier
3. Verify with credit card (won't be charged)

### 2. Create VM Instance
1. **Compute** → **Instances** → **Create Instance**
2. **Name**: `lineageos-builder`
3. **Image**: Ubuntu 22.04 (or latest)
4. **Shape**: 
   - VM.Standard.A1.Flex (ARM) - Recommended: 4 OCPUs, 24GB RAM
   - OR VM.Standard.E2.1.Micro (AMD) - 1 OCPU, 1GB RAM (slower but works)
5. **Boot Volume**: 200GB
6. **Add SSH Key**: Generate or upload your key
7. Click **Create**

### 3. Connect to VM
```bash
# From your local machine
ssh ubuntu@<VM_PUBLIC_IP>
```

### 4. Run Setup Script
```bash
# On the VM
sudo apt update
sudo apt install -y git curl

# Clone your device tree repo
git clone https://github.com/Et18n/android_device_samsung_on7xelte.git
cd android_device_samsung_on7xelte

# Download and run setup script
curl -O https://raw.githubusercontent.com/Et18n/android_device_samsung_on7xelte/main/setup-cloud-build.sh
chmod +x setup-cloud-build.sh
./setup-cloud-build.sh
```

### 5. Build ROM
```bash
# Use screen to run in background (survives SSH disconnection)
screen -S build

cd ~/lineageos
source build/envsetup.sh
lunch lineage_on7xelte-userdebug
mka bacon -j$(nproc)

# Detach from screen: Press Ctrl+A then D
# Reattach: screen -r build
```

### 6. Download ROM
```bash
# On your local machine, download the built ROM
scp ubuntu@<VM_PUBLIC_IP>:~/lineageos/out/target/product/on7xelte/lineage-*.zip ~/Downloads/
```

## Build Time Estimates:
- **ARM (4 OCPUs, 24GB)**: ~3-4 hours
- **AMD (2 OCPUs, 12GB)**: ~6-8 hours

## Tips:
- Keep VM running 24/7 (it's free!)
- Use `htop` to monitor resource usage
- Check disk space: `df -h`
- Monitor build: `tail -f ~/lineageos/out/verbose.log`

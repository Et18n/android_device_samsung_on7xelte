# Oracle Cloud VM Setup - Complete Step-by-Step Guide

## Part 1: Create Oracle Cloud Account (5 minutes)

1. **Go to**: https://www.oracle.com/cloud/free/
2. **Click**: "Start for free" button
3. **Fill in**:
   - Email address
   - Country/Region
   - First/Last Name
4. **Verify** email (check inbox for verification code)
5. **Enter** password and company name (can be anything)
6. **Add payment method** (credit card - won't be charged for Always Free tier)
7. **Wait** for account approval (usually instant, sometimes 15 minutes)

## Part 2: Create VM Instance (3 minutes)

1. **Log in** to Oracle Cloud Console: https://cloud.oracle.com
2. **Click** "Create a VM instance" (on homepage)
   - OR go to: ☰ Menu → Compute → Instances → Create Instance

3. **Configure Instance**:

   **Name**: `lineageos-builder`
   
   **Placement**: Leave default (your home region)
   
   **Image**: 
   - Click "Change Image"
   - Select "Ubuntu" 
   - Choose "Canonical Ubuntu 22.04" (or latest 22.04 version)
   - Click "Select Image"
   
   **Shape**: 
   - Click "Change Shape"
   - Select "Ampere (ARM)" 
   - Choose "VM.Standard.A1.Flex"
   - Set OCPUs: **4** (max free tier)
   - Memory: **24 GB** (max free tier)
   - Click "Select Shape"
   
   **Networking**: Leave default (creates new VCN automatically)
   
   **Add SSH Keys**:
   - Select "Generate SSH key pair"
   - Click "Save Private Key" (downloads .key file)
   - Click "Save Public Key" (downloads .pub file)
   - **IMPORTANT**: Save these files securely!
   
   **Boot Volume**: 
   - Click "Specify a custom boot volume size"
   - Set to **200 GB** (max free tier)

4. **Click** "Create" button at bottom

5. **Wait** 2-3 minutes for instance to provision (status: PROVISIONING → RUNNING)

6. **Copy** the Public IP address (you'll need this to connect)

## Part 3: Connect to Your VM (1 minute)

### On Linux/Mac:

```bash
# Move the private key to .ssh directory
mv ~/Downloads/ssh-key-*.key ~/.ssh/oracle-vm.key
chmod 600 ~/.ssh/oracle-vm.key

# Connect (replace YOUR_VM_IP with the actual IP)
ssh -i ~/.ssh/oracle-vm.key ubuntu@YOUR_VM_IP
```

### On Windows (using PowerShell):

```powershell
# Move key to a safe location
Move-Item ~/Downloads/ssh-key-*.key ~/.ssh/oracle-vm.key

# Connect
ssh -i ~/.ssh/oracle-vm.key ubuntu@YOUR_VM_IP
```

**First connection**: Type `yes` when asked about fingerprint

## Part 4: Run Setup Script (2-3 hours)

Once connected to your VM:

```bash
# Download the setup script
wget https://raw.githubusercontent.com/Et18n/android_device_samsung_on7xelte/main/oracle-vm-setup.sh

# Make it executable
chmod +x oracle-vm-setup.sh

# Run it (this takes 1.5-2 hours for repo sync)
./oracle-vm-setup.sh
```

**You can disconnect** - the script will continue running. To check progress:
```bash
ssh -i ~/.ssh/oracle-vm.key ubuntu@YOUR_VM_IP
# Then check if script is still running: ps aux | grep repo
```

## Part 5: Build the ROM (3-4 hours)

After setup completes:

```bash
# Start a screen session (survives disconnection)
screen -S build

# Navigate to workspace
cd ~/lineageos

# Set up build environment
source build/envsetup.sh

# Select device
lunch lineage_on7xelte-userdebug

# Start build (this takes 3-4 hours)
mka bacon -j$(nproc)
```

**To detach from screen and let it run in background**:
- Press `Ctrl+A`, then press `D`

**To reattach later and check progress**:
```bash
screen -r build
```

**To monitor build from outside screen**:
```bash
# Watch build progress
tail -f ~/lineageos/out/verbose.log

# Check system resources
htop
```

## Part 6: Download the ROM

After build completes (you'll see "Package Complete: ..." message):

### Option A: Direct Download via SCP (Recommended)

From your local machine:
```bash
# Download ROM zip (~700MB)
scp -i ~/.ssh/oracle-vm.key \
  ubuntu@YOUR_VM_IP:~/lineageos/out/target/product/on7xelte/lineage-*.zip \
  ~/Downloads/

# Download recovery image
scp -i ~/.ssh/oracle-vm.key \
  ubuntu@YOUR_VM_IP:~/lineageos/out/target/product/on7xelte/recovery.img \
  ~/Downloads/
```

### Option B: Use a Transfer Service

On the VM:
```bash
# Install transfer.sh client
cd ~/lineageos/out/target/product/on7xelte
curl --upload-file ./lineage-*.zip https://transfer.sh/lineage-rom.zip
# Copy the URL it gives you and download from your browser
```

## Part 7: Flash to Phone

See main README for flashing instructions with TWRP.

---

## Troubleshooting

**VM creation fails "Out of capacity"**:
- Try different shape (VM.Standard.E2.1.Micro - slower but available)
- Try different region (select different home region during signup)

**SSH connection refused**:
- Wait 2-3 minutes after VM shows "RUNNING"
- Check you're using correct IP address
- Verify key permissions: `chmod 600 ~/.ssh/oracle-vm.key`

**Build fails with "Out of memory"**:
- Your VM might have insufficient RAM
- Reduce parallel jobs: use `mka bacon -j2` instead of `-j$(nproc)`

**Can't connect after disconnection**:
- VM might have restarted and gotten new IP
- Check Oracle Cloud Console for current Public IP

**Want to start over**:
```bash
# On VM - delete workspace and start fresh
cd ~
rm -rf lineageos
./oracle-vm-setup.sh
```

---

## Cost: $0.00 Forever

Oracle's Always Free tier includes:
- ✅ Up to 4 ARM-based Ampere A1 cores
- ✅ Up to 24 GB memory
- ✅ Up to 200 GB storage
- ✅ No time limit - run 24/7 if you want
- ✅ No credit card charges (as long as you stay in free tier)

**Your VM will never be shut down or charged for Always Free resources.**

# Arch Linux Specific Notes for Building Custom ROM

## Additional Arch Linux Setup

### Enable Multilib Repository (Required for 32-bit support)

Edit `/etc/pacman.conf` and uncomment:

```bash
[multilib]
Include = /etc/pacman.d/mirrorlist
```

Then update:

```bash
sudo pacman -Sy
```

### Install AUR Helper (Optional but Recommended)

For additional packages not in official repos:

```bash
# Install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### Python Symlink

Arch uses `python` for Python 3 by default, which is correct. No action needed.

### Java Selection

If you have multiple Java versions:

```bash
# List installed Java versions
archlinux-java status

# Set Java 11 as default
sudo archlinux-java set java-11-openjdk
```

### ccache Configuration

Arch-specific ccache setup:

```bash
# Install ccache
sudo pacman -S ccache

# Configure PATH (add to ~/.bashrc)
export PATH="/usr/lib/ccache/bin:$PATH"
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
ccache -M 50G
```

### Common Arch Issues and Fixes

#### Issue: `libncurses.so.5` not found

```bash
# Install from AUR
yay -S ncurses5-compat-libs
```

#### Issue: `/usr/bin/python` not found

```bash
# Should not happen on Arch, but if it does:
sudo ln -s /usr/bin/python3 /usr/bin/python
```

#### Issue: Jack server errors

```bash
# Disable Jack (use newer build system)
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"
```

#### Issue: Out of memory during build

```bash
# Reduce parallel jobs
mka bacon -j4  # or -j2 for systems with less RAM

# Or increase swap
sudo dd if=/dev/zero of=/swapfile bs=1G count=16
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### Recommended AUR Packages

```bash
# Additional tools that might be helpful
yay -S repo
yay -S lineageos-devel  # If available
yay -S lib32-ncurses5-compat-libs
```

### Performance Optimizations for Arch

1. **Use makepkg flags**: Edit `/etc/makepkg.conf`

```bash
MAKEFLAGS="-j$(nproc)"
BUILDENV=(!distcc color ccache check !sign)
```

2. **Use faster compression**: In `/etc/makepkg.conf`

```bash
COMPRESSGZ=(pigz -c -f -n)
COMPRESSZST=(zstd -c -z -q - --threads=0)
```

3. **Disk I/O optimization**: For SSD users

```bash
# Add to /etc/fstab for your build partition
noatime,nodiratime
```

### Arch Linux Build Script Adjustments

The setup script has been updated to detect Arch Linux and use `pacman` automatically.

Just run:

```bash
./setup.sh
```

It will automatically detect you're on Arch and install the correct packages.

## Quick Start for Arch Users

```bash
# 1. Enable multilib (if not already enabled)
sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
sudo pacman -Sy

# 2. Install dependencies
sudo pacman -Syu --needed base-devel bc bison ccache curl flex git gnupg \
  gperf imagemagick lib32-ncurses lib32-readline lib32-zlib lz4 ncurses \
  openssl libxml2 lzop pngcrush rsync schedtool squashfs-tools xz zip zlib \
  jdk11-openjdk python python-pip android-tools wget multilib-devel

# 3. Install repo tool
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

# 4. Configure git
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# 5. Run automated setup
./setup.sh

# 6. Build ROM
./build.sh
```

## Arch-Specific Advantages

✅ Rolling release - always latest packages
✅ Minimal bloat - only what you need
✅ AUR access - community packages
✅ Fast package manager
✅ Up-to-date development tools

## Notes

- Arch's rolling release means tools are usually more up-to-date than Ubuntu
- You might encounter fewer compatibility issues with newer code
- Make sure to keep your system updated: `sudo pacman -Syu`
- The build scripts now auto-detect Arch Linux

Happy building! 🎉

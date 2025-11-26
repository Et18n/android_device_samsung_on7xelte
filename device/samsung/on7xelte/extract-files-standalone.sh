#!/bin/bash
#
# Simple standalone vendor blob extractor for Galaxy J7 Prime
# Use this if you don't have the full LineageOS source
#

set -e

DEVICE=on7xelte
VENDOR=samsung

# Use ADB from platform-tools
ADB="/home/Ethan/Downloads/platform-tools/adb"

echo "========================================"
echo "  Extracting Vendor Blobs"
echo "  Device: Samsung Galaxy J7 Prime"
echo "========================================"
echo ""

# Check if device is connected
if ! $ADB devices | grep -q "device$"; then
    echo "Error: No device connected!"
    echo ""
    echo "Please:"
    echo "1. Enable USB Debugging on your phone"
    echo "2. Connect via USB"
    echo "3. Accept the debugging prompt"
    echo "4. Run this script again"
    exit 1
fi

# Create vendor directory
VENDOR_DIR="../../vendor/$VENDOR/$DEVICE/proprietary"
mkdir -p "$VENDOR_DIR"

echo "Connected device:"
$ADB devices
echo ""
echo "Extracting files..."
echo ""

# Root remount (if device is rooted)
$ADB root 2>/dev/null || true
$ADB wait-for-device
$ADB remount 2>/dev/null || true

# Function to pull file
pull_file() {
    local FILE=$1
    local DEST=$2
    
    if $ADB shell "[ -f $FILE ]" 2>/dev/null; then
        echo "  Pulling: $FILE"
        $ADB pull "$FILE" "$VENDOR_DIR/$DEST" 2>/dev/null || {
            echo "    Warning: Failed to pull $FILE"
        }
    else
        echo "  Missing: $FILE"
    fi
}

# Audio
echo "Extracting Audio files..."
pull_file "/vendor/lib/hw/audio.primary.exynos7870.so" "vendor/lib/hw/"
pull_file "/vendor/lib64/hw/audio.primary.exynos7870.so" "vendor/lib64/hw/"

# Bluetooth
echo "Extracting Bluetooth files..."
pull_file "/vendor/firmware/bcm4343A0_V0054.0303.hcd" "vendor/firmware/"
pull_file "/vendor/lib/hw/bluetooth.default.so" "vendor/lib/hw/"

# Camera
echo "Extracting Camera files..."
pull_file "/vendor/lib/hw/camera.exynos5.so" "vendor/lib/hw/"
pull_file "/vendor/lib/libexynoscamera.so" "vendor/lib/"
pull_file "/vendor/lib64/libexynoscamera.so" "vendor/lib64/"

# GPS
echo "Extracting GPS files..."
pull_file "/vendor/bin/gpsd" "vendor/bin/"
pull_file "/vendor/lib64/hw/gps.default.so" "vendor/lib64/hw/"
pull_file "/vendor/etc/gps.xml" "vendor/etc/"

# Graphics
echo "Extracting Graphics files..."
pull_file "/vendor/lib/egl/libGLES_mali.so" "vendor/lib/egl/"
pull_file "/vendor/lib/hw/gralloc.exynos5.so" "vendor/lib/hw/"
pull_file "/vendor/lib/hw/hwcomposer.exynos5.so" "vendor/lib/hw/"
pull_file "/vendor/lib64/egl/libGLES_mali.so" "vendor/lib64/egl/"
pull_file "/vendor/lib64/hw/gralloc.exynos5.so" "vendor/lib64/hw/"

# RIL
echo "Extracting RIL files..."
pull_file "/vendor/lib64/libsec-ril.so" "vendor/lib64/"
pull_file "/vendor/lib64/libsecnativefeature.so" "vendor/lib64/"

# Sensors
echo "Extracting Sensors files..."
pull_file "/vendor/lib/hw/sensors.exynos7870.so" "vendor/lib/hw/"
pull_file "/vendor/lib64/hw/sensors.exynos7870.so" "vendor/lib64/hw/"

# WiFi
echo "Extracting WiFi files..."
pull_file "/vendor/etc/wifi/bcmdhd_apsta.bin" "vendor/etc/wifi/"
pull_file "/vendor/etc/wifi/bcmdhd_sta.bin" "vendor/etc/wifi/"
pull_file "/vendor/etc/wifi/nvram_net.txt" "vendor/etc/wifi/"

echo ""
echo "========================================"
echo "Extraction Complete!"
echo "========================================"
echo ""
echo "Files extracted to: $VENDOR_DIR"
echo ""
echo "Next steps:"
echo "1. Review extracted files"
echo "2. Commit to vendor repository"
echo "3. Push to GitHub"
echo ""

# Copyright (C) 2024 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Ramdisk
PRODUCT_PACKAGES += \
    fstab.exynos7870 \
    init.exynos7870.rc \
    init.exynos7870.usb.rc \
    ueventd.exynos7870.rc

# Prebuilt ramdisk files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.exynos7870:$(TARGET_COPY_OUT_RAMDISK)/fstab.exynos7870 \
    $(LOCAL_PATH)/rootdir/etc/fstab.exynos7870:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.exynos7870 \
    $(LOCAL_PATH)/rootdir/etc/init.exynos7870.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.exynos7870.rc \
    $(LOCAL_PATH)/rootdir/etc/init.exynos7870.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.exynos7870.usb.rc \
    $(LOCAL_PATH)/rootdir/etc/ueventd.exynos7870.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc

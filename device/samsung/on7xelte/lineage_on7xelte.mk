#
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
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from on7xelte device
$(call inherit-product, device/samsung/on7xelte/device.mk)

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Device identifier
PRODUCT_NAME := lineage_on7xelte
PRODUCT_DEVICE := on7xelte
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G610F
PRODUCT_MANUFACTURER := samsung

# Build fingerprint
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="on7xeltexx-user 8.1.0 M1AJQ.G610FDDU1CRJ1 release-keys"

BUILD_FINGERPRINT := samsung/on7xeltexx/on7xelte:8.1.0/M1AJQ/G610FDDU1CRJ1:user/release-keys

PRODUCT_GMS_CLIENTID_BASE := android-samsung

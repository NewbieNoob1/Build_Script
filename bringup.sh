#!/bin/bash

rm -rf device/xiaomi/munch
rm -rf device/xiaomi/sm8250-common
rm -rf vendor/xiaomi/munch
rm -rf vendor/xiaomi/sm8250-common
rm -rf kernel/xiaomi/sm8250

echo "========================================================================"
echo "DELETED DIRECTORIES"
echo "========================================================================"

# Initiating the Rising OS
repo init -u https://github.com/RisingTechOSS/android -b fourteen --git-lfs

echo "========================================================================"
echo "REPO INITIALIZED"
echo "========================================================================"

# Clone Munch Trees
# 1. Device Tree
git clone https://github.com/NewbieNoob1/device_xiaomi_munch.git --depth=1 -b fourteen device/xiaomi/munch
# 2. Device Common tree
git clone https://github.com/NewbieNoob1/device_xiaomi_sm8250-common.git --depth=1 -b fourteen device/xiaomi/sm8250-common
# 3. Vendor Tree
git clone https://gitea.com/deadlyshroud/vendor_xiaomi_munch.git --depth=1 -b fourteen vendor/xiaomi/munch
# 4. Vendor Common Tree
git clone https://gitea.com/deadlyshroud/vendor_xiaomi_sm8250-common.git --depth=1 -b fourteen vendor/xiaomi/sm8250-common
# 5. Kernel Tree
git clone https://github.com/kvsnr113/xiaomi_sm8250_kernel.git --depth=1 -b main kernel/xiaomi/sm8250

echo "========================================================================"
echo "MUNCH TREES CLONED"
echo "========================================================================"

# Setup Clang toolchain
cd prebuilts/clang/host/linux-x86
mkdir clang-neutron
cd clang-neutron
curl -LO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman"
chmod +x antman
./antman -S=05012024
./antman --patch=glibc
cd ../../../../..

echo "========================================================================"
echo "CLANG-NEUTRON SETUP SUCCESS"
echo "========================================================================"

## Extra Additions

# Hardware Xiaomi
rm -rf hardware/xiaomi
git clone https://github.com/LineageOS/android_hardware_xiaomi.git --depth=1 -b lineage-21 hardware/xiaomi

# Hardware Display
rm -rf hardware/qcom-caf/sm8250/display
git clone https://github.com/hdzungx/android_hardware_qcom-caf_sm8250_display --depth=1 hardware/qcom-caf/sm8250/display

# Miui Camera Repo
git clone https://gitea.com/hdzungx/android_vendor_xiaomi_miuicamera.git --depth=1 -b uqpr3 vendor/xiaomi/miuicamera

# Viper4Android
git clone https://github.com/TogoFire/packages_apps_ViPER4AndroidFX.git --depth=1 -b v4a packages/apps/ViPER4AndroidFX

# Kprofiles 
rm -rf packages/apps/KProfiles
git clone https://github.com/yaap/packages_apps_KProfiles.git --depth=1 -b fourteen packages/apps/KProfiles

echo "========================================================================"
echo "EXTRA ADDITIONS CLONED"
echo "========================================================================"

# Resync

/opt/crave/resync.sh

echo "========================================================================"
echo "RESYNCED"
echo "========================================================================"


# Modify the AndroidManifest.xml
sed -i 's/android:minSdkVersion="19"/android:minSdkVersion="21"/' prebuilts/sdk/current/androidx/m2repository/androidx/preference/preference/1.3.0-alpha01/manifest/AndroidManifest.xml

echo "========================================================================"
echo "ANDROID MANIFEST MODIFIED"
echo "========================================================================"


echo "========================================================================"
echo "BUILDING........."
echo "========================================================================"


# RISEUP
source build/envsetup.sh
riseup munch userdebug
gk -s
rise b

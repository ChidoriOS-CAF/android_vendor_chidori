PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup tool
PRODUCT_COPY_FILES += \
    vendor/chidori/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/chidori/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/chidori/prebuilt/common/bin/50-chidori.sh:system/addon.d/50-chidori.sh \
    vendor/chidori/prebuilt/common/bin/clean_cache.sh:system/bin/clean_cache.sh

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/chidori/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/chidori/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/chidori/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# Backup services whitelist
PRODUCT_COPY_FILES += \
    vendor/chidori/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/chidori/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# Chidori-specific init file
PRODUCT_COPY_FILES += \
    vendor/chidori/prebuilt/common/etc/init.local.rc:root/init.chidori.rc

# Copy LatinIME for gesture typing
PRODUCT_COPY_FILES += \
    vendor/chidori/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/chidori/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/chidori/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/chidori/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

# Specific startup services
PRODUCT_COPY_FILES += \
    vendor/chidori/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/chidori/prebuilt/common/bin/sysinit:system/bin/sysinit

# Required packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    Development \
    SpareParts \
    LockClock \
    su

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# AudioFX
PRODUCT_PACKAGES += \
    AudioFX

# Extra Optional packages
PRODUCT_PACKAGES += \
    Calculator \
    LatinIME \
    BluetoothExt \
    Launcher3Dark

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

PRODUCT_PACKAGES += \
    charger_res_images

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Storage manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=true

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGES += \
    AndroidDarkThemeOverlay \
    SettingsDarkThemeOverlay

PRODUCT_PACKAGE_OVERLAYS += vendor/chidori/overlay/common

# Qualcomm performance frameworks
ifeq ($(USE_QCOM_PERF),true)
    PRODUCT_BOOT_JARS += \
        QPerformance \
        UxPerformance
endif

# Themes
PRODUCT_PROPERTY_OVERRIDES += ro.boot.vendor.overlay.theme=com.google.android.theme.pixel
PRODUCT_PROPERTY_OVERRIDES += ro.com.google.ime.theme_id=5
PRODUCT_PACKAGES += \
   Pixel \
   Stock \
   Mono

# Versioning System
# chidori first version.
PRODUCT_VERSION_MAJOR = 1
PRODUCT_VERSION_MINOR = 0
CHIDORI_PRODUCT_VERSION = $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)
PRODUCT_VERSION_MAINTENANCE = 0
CHIDORI_POSTFIX := -$(shell date +"%Y%m%d")
TARGET_PRODUCT_SHORT := $(subst chidori_,,$(CUSTOM_BUILD))

ifdef CHIDORI_BUILD_EXTRA
    CHIDORI_POSTFIX := -$(CHIDORI_BUILD_EXTRA)
endif

ifndef CHIDORI_BUILD_TYPE
    CHIDORI_BUILD_TYPE := UNOFFICIAL
endif

# Set all versions
CHIDORI_VERSION := ChidoriOS-$(CHIDORI_PRODUCT_VERSION)-$(CHIDORI_BUILD)-$(CHIDORI_BUILD_TYPE)$(CHIDORI_POSTFIX)
CHIDORI_MOD_VERSION := $(CHIDORI_VERSION)
CHIDORI_FINGERPRINT := ChidoriOS/$(CHIDORI_PRODUCT_VERSION)/$(TARGET_PRODUCT_SHORT)/$(CHIDORI_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.chidori.version=$(CHIDORI_VERSION) \
    ro.modversion=$(CHIDORI_VERSION) \
    ro.chidori.build_type=$(CHIDORI_BUILD_TYPE) \
    ro.chidori.build_date=$(CHIDORI_POSTFIX) \
    ro.chidori.fingerprint=$(CHIDORI_FINGERPRINT)

EXTENDED_POST_PROCESS_PROPS := vendor/chidori/tools/chidori_process_props.py

-include vendor/chidori/config/qualcomm.mk

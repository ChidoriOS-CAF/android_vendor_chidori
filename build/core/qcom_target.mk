# Bring in Qualcomm helper macros
include vendor/chidori/build/core/qcom_utils.mk

# Set device-specific HALs into project pathmap
define set-device-specific-path
$(if $(USE_DEVICE_SPECIFIC_$(1)), \
    $(if $(DEVICE_SPECIFIC_$(1)_PATH), \
        $(eval path := $(DEVICE_SPECIFIC_$(1)_PATH)), \
        $(eval path := $(TARGET_DEVICE_DIR)/$(2))), \
    $(eval path := $(3))) \
$(call project-set-path,qcom-$(2),$(strip $(path)))
endef

# How this works:
# If the user didn't override TARGET_PRODUCT_HALS, set them according to his platform.
ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
REVI ?= pie-caf

TARGET_PRODUCT_HALS ?= \
hardware/qcom/audio:hardware_qcom_audio:$(REMOTE):$(REVI)-$(QCOM_HARDWARE_VARIANT) \
hardware/qcom/display:hardware_qcom_display:$(REMOTE):$(REVI)-$(QCOM_HARDWARE_VARIANT) \
hardware/qcom/media:hardware_qcom_media:$(REMOTE):$(REVI)-$(QCOM_HARDWARE_VARIANT) \
hardware/qcom/camera:hardware_qcom_camera:$(REMOTE):$(REVI) \
hardware/qcom/gps:hardware_qcom_gps:$(REMOTE):$(REVI) \
vendor/qcom/opensource/location:vendor_qcom_opensource_location:$(REMOTE):$(REVI) \
vendor/qcom/opensource/dataservices:vendor_qcom_opensource_dataservices:$(REMOTE):$(REVI) \
hardware/qcom/power:hardware_qcom_power:$(REMOTE):$(REVI) \
hardware/ril:hardware_ril:$(REMOTE):$(REVI) \
hardware/qcom/wlan:hardware_qcom_wlan:$(REMOTE):$(REVI) \
hardware/qcom/bt:hardware_qcom_bt:$(REMOTE):$(REVI)

else
REVI ?= pie

TARGET_PRODUCT_HALS ?= \
hardware/qcom/audio/default:hardware_qcom_audio:$(REMOTE):$(REVI) \
hardware/qcom/display:hardware_qcom_display:$(REMOTE):$(REVI) \
hardware/qcom/media:hardware_qcom_media:$(REMOTE):$(REVI) \
hardware/qcom/camera:hardware_qcom_camera:$(REMOTE):$(REVI) \
hardware/qcom/gps:hardware_qcom_gps:$(REMOTE):$(REVI) \
vendor/qcom/opensource/location:vendor_qcom_opensource_location:$(REMOTE):$(REVI) \
hardware/ril:hardware_ril:$(REMOTE):$(REVI) \
hardware/qcom/wlan:hardware_qcom_wlan:$(REMOTE):$(REVI) \
hardware/qcom/bt:hardware_qcom_bt:$(REMOTE):$(REVI)
endif

# How this works:
# TARGET_PRODUCT_HALS is outputted into a script that generates the manifest using it, then the manifest is synced.
# TODO: Make this more robust
# DONE: Allow the user to override the remote
.PHONY: hals
hals :
	$(shell echo $(TARGET_PRODUCT_HALS) > target_hals)
	$(shell vendor/chidori/build/tools/halsync.sh)
	unset TARGET_PRODUCT_HALS
	unset REVI

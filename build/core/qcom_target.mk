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
hardware/qcom/audio:$(REVI)-$(QCOM_HARDWARE_VARIANT) \
hardware/qcom/display:$(REVI)-$(QCOM_HARDWARE_VARIANT) \
hardware/qcom/media:$(REVI)-$(QCOM_HARDWARE_VARIANT) \
hardware/qcom/camera:$(REVI) \
hardware/qcom/gps:$(REVI) \
hardware/qcom/sensors:$(REVI) \
vendor/qcom/opensource/location:$(REVI) \
vendor/qcom/opensource/dataservices:$(REVI) \
hardware/qcom/power:$(REVI) \
hardware/ril:$(REVI) \
hardware/wlan:$(REVI) \
hardware/bt:$(REVI)

else
REVI ?= pie

TARGET_PRODUCT_HALS ?= \
hardware/qcom/audio/default:$(REVI) \
hardware/qcom/display:$(REVI) \
hardware/qcom/media:$(REVI) \
hardware/qcom/camera:$(REVI) \
hardware/qcom/gps:$(REVI) \
hardware/qcom/sensors:$(REVI) \
vendor/qcom/opensource/location:$(REVI) \
hardware/ril:$(REVI) \
hardware/wlan:$(REVI) \
hardware/bt:$(REVI)
endif

# How this works:
# TARGET_PRODUCT_HALS is outputted into a script that generates the manifest using it, then the manifest is synced.
# TODO: Make this more robust and allow the user to override the remote
.PHONY: hals
hals :
	$(shell echo $(TARGET_PRODUCT_HALS) > target_hals)
	$(shell vendor/chidori/build/tools/halsync.sh)
	unset TARGET_PRODUCT_HALS
	unset REVI

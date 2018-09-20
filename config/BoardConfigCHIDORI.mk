# Charger
#ifneq ($(WITH_CM_CHARGER),false)
#    BOARD_HAL_STATIC_LIBRARIES := libhealthd.cm
#endif

include vendor/chidori/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/chidori/config/BoardConfigQCOM.mk
endif

include vendor/chidori/config/BoardConfigSoong.mk

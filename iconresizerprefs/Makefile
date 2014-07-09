include theos/makefiles/common.mk
export ARCHS = armv7 armv7s arm64
BUNDLE_NAME = iconresizerprefs
iconresizerprefs_FILES = iconresizerprefs.mm indieSliders.mm namedSlider.mm
iconresizerprefs_INSTALL_PATH = /Library/PreferenceBundles
iconresizerprefs_FRAMEWORKS = UIKit
iconresizerprefs_PRIVATE_FRAMEWORKS = Preferences
iconresizerprefs_LIBRARIES = applist
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/iconresizerprefs.plist$(ECHO_END)

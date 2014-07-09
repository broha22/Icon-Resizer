include theos/makefiles/common.mk
export ARCHS = armv7 armv7s arm64
TWEAK_NAME = IconResizer
IconResizer_FILES = Tweak.xm
IconResizer_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += iconresizerprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

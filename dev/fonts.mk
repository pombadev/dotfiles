# fonts

# Noto font family — package names differ between distros
PKG += noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

ifeq ($(OS_ID),fedora)
PKG_noto-fonts       := google-noto-fonts-common
PKG_noto-fonts-cjk   := google-noto-cjk-fonts
PKG_noto-fonts-emoji := google-noto-emoji-fonts
PKG_noto-fonts-extra := google-noto-sans-fonts
endif

# MS fonts: AUR on Arch; not available on Fedora
ifeq ($(OS_ID),arch)
AUR += ttf-ms-fonts
else
.PHONY: ttf-ms-fonts
ttf-ms-fonts:
	@echo "ttf-ms-fonts not available on $(OS_ID), skipping"
endif

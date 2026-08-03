# language toolchains

PKG += nodejs npm go rustup

# dotnet-sdk package has a version suffix on Fedora
ifeq ($(OS_ID),fedora)
PKG_dotnet-sdk := dotnet-sdk-9.0
endif
PKG += dotnet-sdk

# dart: in AUR on Arch; install via snap on Fedora
ifeq ($(OS_ID),arch)
AUR += dart
else
.PHONY: dart
dart:
	@echo "installing/upgrading $@..."
	@sudo snap install dart --classic
endif

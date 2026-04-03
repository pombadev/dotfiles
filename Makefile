SHELL := /bin/bash

# ── home-maker ────────────────────────────────────────────────────────────────
# One Makefile to install and upgrade every tool on your dev machine.
# Supports Arch Linux (pacman/paru) and Fedora (dnf).
# Inspired by https://github.com/santhoshtr/hm

# ── detect OS ─────────────────────────────────────────────────────────────────
OS_ID := $(shell . /etc/os-release 2>/dev/null && echo $$ID || echo unknown)

# ── package group includes ────────────────────────────────────────────────────
include dev/cli.mk
include dev/langs.mk
include dev/rust.mk
include dev/fonts.mk

include desktop/apps.mk
include desktop/gnome.mk

# ── package manager commands ──────────────────────────────────────────────────
ifeq ($(OS_ID),arch)
  PKG_INSTALL := sudo pacman -Syyuu --needed
  AUR_INSTALL := paru -Syu --needed
else ifeq ($(OS_ID),fedora)
  PKG_INSTALL := sudo dnf install -y
  AUR_INSTALL := echo
else
  $(warning Unknown OS '$(OS_ID)'. Defaulting to dnf.)
  PKG_INSTALL := sudo dnf install -y
  AUR_INSTALL := echo
endif

CARGO_INSTALL := cargo install
GO_INSTALL    := go install
NPM_INSTALL   := sudo npm i -g

# ── helper functions ──────────────────────────────────────────────────────────

# Split "name@version" → name and version
pkg-name    = $(firstword $(subst @, ,$(1)))
pkg-version = $(word 2,$(subst @, ,$(1)))

# Use PKG_<name> override when the Make target name differs from the package
# name the manager expects (e.g. libreoffice → libreoffice-fresh on Arch).
pkg-pkgname = $(or $(PKG_$(call pkg-name,$(1))),$(call pkg-name,$(1)))

# ── target generators ─────────────────────────────────────────────────────────

define gen-pkg
.PHONY: $(call pkg-name,$(1))
$(call pkg-name,$(1)):
	@echo "installing/upgrading $$@..."
	@$(PKG_INSTALL) $(call pkg-pkgname,$(1))
endef

ifeq ($(OS_ID),arch)
define gen-aur
.PHONY: $(call pkg-name,$(1))
$(call pkg-name,$(1)):
	@echo "installing/upgrading $$@..."
	@$(AUR_INSTALL) $(call pkg-pkgname,$(1))
endef
else
define gen-aur
.PHONY: $(call pkg-name,$(1))
$(call pkg-name,$(1)):
	@echo "Skipping AUR package $$@ (not available on $(OS_ID))"
endef
endif

define gen-cargo
.PHONY: $(call pkg-name,$(1))
$(call pkg-name,$(1)):
	@echo "installing/upgrading $$@..."
	@$(CARGO_INSTALL) $(call pkg-pkgname,$(1))
endef

define gen-go
.PHONY: $(call pkg-name,$(1))
$(call pkg-name,$(1)):
	@echo "installing/upgrading $$@..."
	@$(GO_INSTALL) $(call pkg-pkgname,$(1))@$(or $(call pkg-version,$(1)),latest)
endef

define gen-npm
.PHONY: $(call pkg-name,$(1))
$(call pkg-name,$(1)):
	@echo "installing/upgrading $$@..."
	@$(NPM_INSTALL) $(call pkg-pkgname,$(1))$(if $(call pkg-version,$(1)),@$(call pkg-version,$(1)))
endef

# ── generate targets from accumulated package lists ───────────────────────────

$(foreach p,$(PKG),$(eval $(call gen-pkg,$(p))))
$(foreach p,$(AUR),$(eval $(call gen-aur,$(p))))
$(foreach p,$(CARGO),$(eval $(call gen-cargo,$(p))))
$(foreach p,$(GO),$(eval $(call gen-go,$(p))))
$(foreach p,$(NPM),$(eval $(call gen-npm,$(p))))

# ── group targets ─────────────────────────────────────────────────────────────

.PHONY: cli
cli: build-tools fzf git cmake zsh zsh-completions neovim bash-completion man-db man-pages eza zoxide

.PHONY: langs
langs: nodejs npm go dotnet-sdk rustup dart

.PHONY: rust
rust: sccache configman gprofile cargo-cache cargo-edit

.PHONY: fonts
fonts: noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-ms-fonts

.PHONY: apps
apps: firefox tilix libreoffice gnome-browser-connector vscode pycharm zoom

# ── top-level targets ─────────────────────────────────────────────────────────

.PHONY: dev
dev: cli langs rust

.PHONY: desktop
desktop: fonts apps gnome

.PHONY: dirs
dirs:
	@echo "Creating directories..."
	@mkdir -p ~/Projects ~/Work ~/.npm/packages/bin ~/.pub-cache/bin

.PHONY: link-dots
link-dots:
	@echo "Linking config files..."
	@configman --src=. --dest=~

.PHONY: aur-helper
aur-helper:
	@if [ "$(OS_ID)" != "arch" ]; then \
		echo "paru is only for Arch Linux"; exit 1; \
	fi
	@if ! command -v paru &>/dev/null; then \
		tmpdir=$$(mktemp -d) && \
		git clone https://aur.archlinux.org/paru.git "$$tmpdir/paru" && \
		cd "$$tmpdir/paru" && makepkg -si && \
		rm -rf "$$tmpdir"; \
	else \
		echo "paru is already installed"; \
	fi

.PHONY: all
all: dirs dev desktop

.PHONY: hm
hm:
	@bash "$(CURDIR)/hm.sh"

.PHONY: clean
clean:
	@echo "cleaning cargo..."
	@cargo-cache -a 2>/dev/null || true
	@. /etc/os-release 2>/dev/null; \
	if [ "$$ID" = "arch" ]; then \
		echo "cleaning pacman cache..."; \
		sudo pacman -Sc --noconfirm; \
	elif [ "$$ID" = "fedora" ]; then \
		echo "cleaning dnf cache..."; \
		sudo dnf clean all; \
	fi
	@echo "cleaning npm..."
	@npm cache clean --force 2>/dev/null || true
	@echo "cleaning go..."
	@go clean -cache 2>/dev/null || true
	@echo "all caches cleaned"

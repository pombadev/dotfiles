# desktop applications

PKG += firefox tilix

# libreoffice: 'libreoffice-fresh' on Arch, 'libreoffice' on Fedora
PKG += libreoffice
ifeq ($(OS_ID),arch)
PKG_libreoffice := libreoffice-fresh
endif

# gnome-browser-connector: AUR on Arch, official repo on Fedora
ifeq ($(OS_ID),arch)
AUR += gnome-browser-connector
else
PKG += gnome-browser-connector
endif

# snapd: AUR on Arch, official repo on Fedora
ifeq ($(OS_ID),arch)
AUR += snapd
else
PKG += snapd
endif

# VSCode — installed via snap on both distros
.PHONY: vscode
vscode: snapd-setup
	@echo "installing/upgrading $@..."
	@sudo snap install code --classic

# PyCharm Community — installed via snap on both distros
.PHONY: pycharm
pycharm: snapd-setup
	@echo "installing/upgrading $@..."
	@sudo snap install pycharm-community --classic

# zoom: AUR on Arch; direct RPM download on Fedora
ifeq ($(OS_ID),arch)
AUR += zoom
else
.PHONY: zoom
zoom:
	@echo "installing/upgrading $@..."
	@tmpdir=$$(mktemp -d) && \
	curl -fsSL "https://zoom.us/client/latest/zoom_x86_64.rpm" \
		-o "$$tmpdir/zoom.rpm" && \
	sudo dnf install -y "$$tmpdir/zoom.rpm" && \
	rm -rf "$$tmpdir"
endif

# snapd post-install setup (enable service, create /snap symlink)
.PHONY: snapd-setup
snapd-setup: snapd
	@echo "setting up snapd..."
	@sudo systemctl enable --now snapd.socket
	@if [ ! -e /snap ]; then \
		sudo ln -s /var/lib/snapd/snap /snap; \
	fi
	@echo "waiting for snapd to initialise..."
	@sleep 5
	@echo "snapd initialized"

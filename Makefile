SHELL = /usr/bin/bash

home: dirs preferences deps
	@echo "All done, reboot is strongly recommended."

dirs:
	@echo "Creating folders"
	mkdir -p ~/Projects ~/Work ~/.npm/packages/bin ~/.pub-cache/bin

preferences:
	@echo "Applying gnome settings"
	gsettings set org.gnome.desktop.datetime automatic-timezone true
	gsettings set org.gnome.desktop.interface clock-format '12h'
	gsettings set org.gnome.desktop.interface clock-show-date true
	gsettings set org.gnome.desktop.interface clock-show-weekday true
	gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
	gsettings set org.gnome.desktop.interface show-battery-percentage true
	gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
	gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
	gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
	gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
	gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Alt>Tab']"
	gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Alt>Tab']"
	gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>Tab']"
	gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Super>Tab']"
	gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

.ONESHELL:
deps:
	@echo "Installing essential packages"
	sudo pacman -Syyuu --needed \
		base-devel \
		fzf \
		git \
		cmake \
		firefox \
		tilix \
		nodejs \
		noto-fonts \
		noto-fonts-cjk \
		noto-fonts-emoji \
		noto-fonts-extra \
		npm \
		rustup \
		zsh \
		zsh-completions \
		neovim \
		libreoffice-fresh \
		bash-completion \
		dart \
		dotnet-sdk \
		go \
		man-db \
		man-pages

	# curl \
	# 	--fail \
	# 	--no-progress-meter \
	# 	--show-error \
	# 	--output-dir zsh \
	# 	--remote-name-all  "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/{key-bindings,completion}.zsh"

	@echo "Set up rust compiler & its components"
	rustup toolchain install stable
	rustup set profile default
	cargo install sccache
	export PATH="$PATH:$HOME/.cargo/bin"
	export RUSTC_WRAPPER=$(which sccache)
	cargo install configman

	@echo "Linking config files"

	configman --src=. --dest=~

	(
		# installing AUR helper
		cd /tmp
		git clone https://aur.archlinux.org/paru.git
		cd paru
		makepkg -si
	)

	cargo install bat cargo-edit cargo-expand cargo-watch evcxr exa git-profile


	paru -Syu --needed snapd chrome-gnome-shell google-chrome zoom shellcheck-bin ttf-ms-fonts


	@echo "Installing snaps packages"
	sudo systemctl enable --now snapd.socket

	if [[ ! -d /snap ]]; then
		sudo ln -s /var/lib/snapd/snap /snap
	fi

	sleep 10s

	sudo snap install code --classic
	sudo snap install pycharm-community --classic

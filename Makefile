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
		guake \
		nodejs \
		noto-fonts \
		noto-fonts-cjk \
		noto-fonts-emoji \
		noto-fonts-extra \
		npm \
		rustup \
		zsh \
		zsh-completions \
		vlc \
		vim \
		neovim \
		libreoffice-fresh \
		git-delta

	@echo "Installing sublime"
	curl -O https://download.sublimetext.com/sublimehq-pub.gpg
	sudo pacman-key --add sublimehq-pub.gpg
	sudo pacman-key --lsign-key 8A8F901A
	rm sublimehq-pub.gpg
	echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
	sudo pacman -Syu --needed sublime-text sublime-merge

	@echo "Set up rust compiler & its components"
	rustup toolchain install stable
	rustup set profile complete
	cargo install sccache
	export RUSTC_WRAPPER=$(which sccache)

	(
		# installing AUR helper
		cd /tmp
		git clone https://aur.archlinux.org/paru.git
		cd paru
		makepkg -si
	)

	cargo install bat cargo-edit cargo-expand cargo-watch evcxr exa git-profile configman

	paru -Syu --needed snapd chrome-gnome-shell google-chrome zoom shellcheck-bin

	@echo "Installing snaps"
	sudo systemctl enable --now snapd.socket
	sudo snap install code --classic
	sudo snap install pycharm-community --classic

	@echo "Linking config files"

	configman --src=. --dest=~

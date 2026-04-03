# GNOME desktop preferences

.PHONY: gnome
gnome:
	@echo "Applying GNOME settings..."
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

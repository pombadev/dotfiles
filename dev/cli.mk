# core CLI tools every developer uses

PKG += fzf git cmake zsh zsh-completions neovim bash-completion man-db man-pages

CARGO += eza zoxide

# base-devel on Arch, "Development Tools" group on Fedora
.PHONY: build-tools
build-tools:
	@echo "installing/upgrading $@..."
	@. /etc/os-release 2>/dev/null; \
	if [ "$$ID" = "arch" ]; then \
		sudo pacman -Syyuu --needed base-devel; \
	elif [ "$$ID" = "fedora" ]; then \
		sudo dnf groupinstall -y "Development Tools"; \
	else \
		echo "Unsupported OS: $$ID, skipping $@"; \
	fi

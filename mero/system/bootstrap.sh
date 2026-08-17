#!/usr/bin/env bash

# Fresh-machine entry point. Run on a bare Arch install, as your normal user:
#
#   curl -fsSL https://raw.githubusercontent.com/pombadev/dotfiles/master/mero/system/bootstrap.sh | bash
#
# Pulls the dotfiles repo (configs) and then replays the system snapshot
# (packages, services, /etc, toolchains) with archify.

set -euo pipefail

REPO=${DOTFILES_REPO:-https://github.com/pombadev/dotfiles.git}

info() { printf '\e[34m==>\e[0m \e[1m%s\e[0m\n' "$*"; }
die() { printf '\e[31merror\e[0m %s\n' "$*" >&2; exit 1; }

[[ $EUID -ne 0 ]] || die "run as your normal user, not root"
[[ -f /etc/arch-release ]] || die "this expects Arch Linux"

info "Installing prerequisites"
sudo pacman -Sy --needed --noconfirm git base-devel curl

if [[ ! -d $HOME/dotfiles ]]; then
    info "Fetching dotfiles"
    git clone --bare "$REPO" "$HOME/dotfiles"

    cmx() { git --git-dir="$HOME/dotfiles" --work-tree="$HOME" "$@"; }

    # Overwrites stock files (.bashrc etc) shipped by the base install.
    cmx checkout -f
    cmx config --local status.showUntrackedFiles no
    cmx submodule update --init --recursive --remote --force
else
    info "dotfiles already present — skipping clone"
fi

[[ -x $HOME/mero/bin/archify ]] || die "archify missing — dotfiles checkout looks incomplete"

info "Replaying system snapshot"
"$HOME/mero/bin/archify" restore "$@"

info "Done. Reboot to pick up services, groups, and locale."

#!/usr/bin/env bash

declare __PATH__

# nodejs
__PATH__+="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/.npm/packages/bin"

# rust stuffs
__PATH__+=":$HOME/.cargo/bin"
if sh -c 'which --skip-alias sccache' &>/dev/null; then
	__PATH__+=":$RUSTC_WRAPPER=$(which sccache)"
fi

# misc
export EDITOR=nano
__PATH__+=":$HOME/.local/bin"

# allow packages downgrade
if [[ $(grep -P '^ID=' /etc/os-release) == *manjaro ]]; then
    # shellcheck disable=SC2034
    DOWNGRADE_FROM_ALA=1
fi

# dart
__PATH__+=":$HOME/.pub-cache/bin"

# deno
export DENO_INSTALL="$HOME/.deno"
__PATH__+=":$DENO_INSTALL/bin"

# haskell
[ -f ~/.ghcup/env ] && source ~/.ghcup/env

# dotnet
export DOTNET_ROOT="$HOME/.dotnet"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
__PATH__+=":$DOTNET_ROOT:$DOTNET_ROOT/tools"

# ocaml
if command -v opam &>/dev/null; then
	shell_type=$(ps $$ | tail -n1 | awk -F' ' '{print $NF}')
	ocaml_init_file="$HOME/.opam/opam-init/init.$shell_type"

	if [[ -f $ocaml_init_file ]]; then
		source "$ocaml_init_file"
	fi

	unset shell_type
	unset ocaml_init_file
fi

# export path once only
export PATH="$__PATH__:$PATH"
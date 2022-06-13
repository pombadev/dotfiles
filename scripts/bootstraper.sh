#!/usr/env bash

declare __PATH__="$PATH"

# nodejs
if command -v node &>/dev/null; then
    __PATH__+=":$HOME/.yarn/bin"
    __PATH__+=":$HOME/.config/yarn/global/node_modules/.bin"
    __PATH__+=":$HOME/.npm/packages/bin"
fi

# rust
if [ -f "$HOME/.cargo/env" ]; then
    source ~/.cargo/env

    if command -v sccache &>/dev/null; then
        export RUSTC_WRAPPER=$(which sccache)
    fi
fi

# dart
if command -v dart &>/dev/null; then
    __PATH__+=":$HOME/.pub-cache/bin"
fi

# deno
if command -v deno &>/dev/null; then
    export DENO_INSTALL="$HOME/.deno"
    __PATH__+=":$DENO_INSTALL/bin"
fi

# haskell
if [ -f ~/.ghcup/env ] &>/dev/null; then
    source ~/.ghcup/env
fi

# dotnet
if command -v dotnet &>/dev/null; then
    export DOTNET_CLI_TELEMETRY_OPTOUT=1

    DOTNET_PATH=$(which dotnet)

    if [[ ${DOTNET_PATH%${DOTNET_PATH#/*/}} == "/home/" ]]; then
        export DOTNET_ROOT="$HOME/.dotnet"

        __PATH__+=":$DOTNET_ROOT:$DOTNET_ROOT/tools"
    fi

    unset DOTNET_PATH
fi

export PATH="$__PATH__"

# NOTE: PLACE CODE IF SOURCE/EXPORT DOESN'T WORK BEFORE EXPORT

# since fedora takes forever to update packages and some are
# straight-up unavailable eg: dart-lang, so i'm forced to use Homebrew
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    # export HOMEBREW_NO_ANALYTICS=1
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# ocaml
if command -v opam &>/dev/null; then
    shell_type=$(ps -p $$ | tail -n1 | awk -F' ' '{print $NF}')
    ocaml_init_file="$HOME/.opam/opam-init/init.$shell_type"

    if [[ -f $ocaml_init_file ]]; then
        source "$ocaml_init_file"
    fi

    unset shell_type
    unset ocaml_init_file
fi


# go
if command -v go &> /dev/null; then
    GO_PATH=$(go env | grep GOPATH | grep -o '"[^"]\+"' | sed -e 's/"//g')

    if [ -d "$GO_PATH" ]; then
        export PATH="$PATH:$GO_PATH/bin"
    fi

    unset GO_PATH
fi

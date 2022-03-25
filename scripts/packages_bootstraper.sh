#!/usr/env bash

declare __PATH__="$PATH"

# nodejs
if command node &>/dev/null; then
    __PATH__+=":$HOME/.yarn/bin"
    __PATH__+=":$HOME/.config/yarn/global/node_modules/.bin"
    __PATH__+=":$HOME/.npm/packages/bin"
fi

# rust
if command rustc &>/dev/null; then
    __PATH__+=":$HOME/.cargo/bin"

    if sh -c 'which --skip-alias sccache' &>/dev/null; then
        __PATH__+=":$RUSTC_WRAPPER=$(which sccache)"
    fi
fi

# dart
if command dart &>/dev/null; then
    __PATH__+=":$HOME/.pub-cache/bin"
fi

# deno
if command deno &>/dev/null; then
    export DENO_INSTALL="$HOME/.deno"
    __PATH__+=":$DENO_INSTALL/bin"
fi

# haskell
if [ -f ~/.ghcup/env ] &>/dev/null; then
    source ~/.ghcup/env
fi

# dotnet
if command dotnet &>/dev/null; then
    export DOTNET_CLI_TELEMETRY_OPTOUT=1

    DOTNET_PATH=$(which dotnet)

    if [[ ${DOTNET_PATH%${DOTNET_PATH#/*/}} == "/home/" ]]; then
        export DOTNET_ROOT="$HOME/.dotnet"

        __PATH__+=":$DOTNET_ROOT:$DOTNET_ROOT/tools"
    fi

    unset DOTNET_PATH
fi

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

# go
if go env &>/dev/null; then
    GO_PATH=$(go env | grep GOPATH | grep -o '"[^"]\+"' | sed -e 's/"//g')

    if [ -d "$GO_PATH" ]; then
        __PATH__+="$PATH:$GO_PATH/bin"
    fi

    unset GO_PATH
fi

# since fedora takes forever to update packages and some are
# straight-up unavailable eg: dart-lang, so i'm forced to use Homebrew
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    export HOMEBREW_NO_ANALYTICS=1
fi

export PATH="$__PATH__"

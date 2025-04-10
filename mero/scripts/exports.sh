#!/usr/env bash

declare __PATH__

__PATH__+=":$HOME/.local/bin"

# allow packages downgrade
# if [[ $(grep -P '^ID=' /etc/os-release) == *manjaro ]]; then
#     export DOWNGRADE_FROM_ALA=1
# fi

if command -v difft &>/dev/null; then
    export GIT_EXTERNAL_DIFF=difft
fi

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

    if [[ ${DOTNET_PATH%"${DOTNET_PATH#/*/}"} == "/home/" ]]; then
        export DOTNET_ROOT="$HOME/.dotnet"

        __PATH__+=":$DOTNET_ROOT:$DOTNET_ROOT/tools"
    fi

    unset DOTNET_PATH
fi

if [ -f "$HOME/.deno/bin/deno" ]; then
    export DENO_INSTALL="$HOME/.deno"
    __PATH__+=":$DENO_INSTALL/bin"
fi

# python
__PATH__+=":$HOME/.poetry/bin"

# erlang
__PATH__+=":$HOME/.cache/rebar3/bin"

export ANDROID_HOME="$HOME/Android/Sdk"
__PATH__+=":$ANDROID_HOME/build-tools/35.0.0"
__PATH__+=":$ANDROID_HOME/platform-tools"
__PATH__+=":$ANDROID_HOME/cmdline-tools/latest/bin"


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

# golang
if command -v go &>/dev/null; then
    GO_PATH="$(go env GOPATH)"

    if [ -d "$GO_PATH" ]; then
        __PATH__+=":$GO_PATH/bin"
    fi

    unset GO_PATH
fi

export PATH="$__PATH__:$PATH"

export EDITOR=nvim

# pnpm
export PNPM_HOME="/home/pjmp/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

#!/usr/env bash

declare __PATH__

__PATH__+=":$HOME/.local/bin"
__PATH__+=":$DOTFILES_ROOT/bin"

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
__PATH__+=":$ANDROID_HOME/platform-tools"
__PATH__+=":$ANDROID_HOME/cmdline-tools/latest/bin"
# __PATH__+=":$ANDROID_HOME/build-tools/35.0.0"
for version in $ANDROID_HOME/build-tools/*; do
    __PATH__+=":$version"
done


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

# macOS-only paths
if [[ "$(uname)" == "Darwin" ]]; then
    if [ -d "/opt/homebrew" ]; then
        __PATH__+=":/opt/homebrew/bin"
        __PATH__+=":/opt/homebrew/opt/coreutils/libexec/gnubin"
    fi

    if command -v brew &>/dev/null; then
        __PATH__+=":/opt/homebrew/opt/php@8.2/bin"
        __PATH__+=":/opt/homebrew/opt/php@8.2/sbin"
        __PATH__+=":/opt/homebrew/opt/ruby/bin"
        __PATH__+=":/opt/homebrew/lib/ruby/gems/3.4.0/bin"
        __PATH__+=":/opt/homebrew/opt/mysql-client@8.4/bin"
    fi

    export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    __PATH__+=":$ANDROID_HOME/emulator"
    __PATH__+=":$ANDROID_HOME/platform-tools"
    __PATH__+=":$ANDROID_HOME/cmdline-tools/bin"

    FNM_MAC_PATH="$HOME/Library/Application Support/fnm"
    if [ -d "$FNM_MAC_PATH" ]; then
        __PATH__+=":$FNM_MAC_PATH"
    fi
    unset FNM_MAC_PATH
fi

# executables dropped anywhere under ~/.local/pkgman
if [ -d "$HOME/.local/pkgman" ]; then
    PKGMAN_PATH="$(find "$HOME/.local/pkgman" -type f -executable -exec sh -c 'dirname "$1" | tr "\n" ":"' shell {} \;)"
    __PATH__+=":${PKGMAN_PATH%:}"
    unset PKGMAN_PATH
fi

export PATH="$__PATH__:$PATH"

if command -v nvim &>/dev/null; then
    export EDITOR=nvim
else
    export EDITOR=nano
fi

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# proto
export PROTO_HOME="$HOME/.proto"
export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH"

export PATH="$HOME/.composer/vendor/bin:$PATH"

export COMPOSE_BAKE=true
export COMPOSE_MENU=false

export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

export EGET_BIN="$HOME/.local/bin"

if command -v ollama &>/dev/null; then
    export OLLAMA_NUM_PARALLEL=$(nproc)
fi

# LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"

if command -v fnm &>/dev/null; then
    eval "$(fnm env --use-on-cd)"
fi

#!/usr/bin/env bash

# nodejs stuffs
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.npm/packages/bin"

# rust stuffs
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH=$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src

# misc
export EDITOR=nano

if sh -c 'which --skip-alias sccache' &> /dev/null; then
	RUSTC_WRAPPER=$(which sccache)
	export RUSTC_WRAPPER
fi

# manjaro (downgrader)
export DOWNGRADE_FROM_ALA=1

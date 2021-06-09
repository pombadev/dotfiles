#!/usr/bin/env bash

# nodejs stuffs
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH=$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src
export EDITOR=nano

if sh -c 'which --skip-alias sccache' &> /dev/null; then
	export RUSTC_WRAPPER=$(which sccache)
fi

DOWNGRADE_FROM_ALA=1

#!/usr/bin/env bash
# hm — home maker: fuzzy install/upgrade packages and groups

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GROUP_TARGETS="cli langs rust fonts apps gnome dev desktop dirs aur-helper link-dots all"
META_TARGETS="hm Makefile clean"

exclude_patterns() {
	printf '%s\n' "$META_TARGETS"
	echo "$GROUP_TARGETS" | tr ' ' '\n'
}

packages() {
	make -pn -C "$SCRIPT_DIR" 2>/dev/null |
		grep -E '^[a-zA-Z][a-zA-Z0-9_-]*:' |
		sed 's/:.*//' |
		grep -vxF -f <(exclude_patterns) |
		sort -u
}

list() {
	printf '# ── groups ──────────────────────────────\n'
	echo "$GROUP_TARGETS" | tr ' ' '\n'
	printf '# ── packages ────────────────────────────\n'
	packages
}

while true; do
	selected=$(list | fzf \
		--multi \
		--prompt "install > " \
		--reverse \
		--height 60% \
		--preview "make -n -C '$SCRIPT_DIR' {} 2>/dev/null" \
		--preview-window "right:50%:wrap" \
		--color "header:italic" \
		--ansi) || break

	[[ -z "$selected" ]] && break

	while IFS= read -r target; do
		[[ "$target" == \#* ]] && continue
		echo ">>> make $target"
		make -C "$SCRIPT_DIR" "$target"
	done <<<"$selected"
done

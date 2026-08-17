#!/usr/bin/env bash
# Claude Code status line. Reads session JSON on stdin, prints one line.
# Managed by the statusline-setup agent — ask Claude to adjust rather than
# hand-editing, or it will get clobbered on the next regen.

input=$(cat)

# dim palette (status line renders dim in the footer)
c_reset=$'\033[0m'
c_dir=$'\033[2;36m'
c_git=$'\033[2;33m'
c_dirty=$'\033[2;31m'
c_clean=$'\033[2;32m'
c_wt=$'\033[2;95m'
c_model=$'\033[2;35m'
c_ctx=$'\033[2;34m'
c_usage=$'\033[2;37m'
sep=$'\033[2m \xc2\xb7 \033[0m'

parts=()

# --- current directory ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
if [ -n "$cwd" ]; then
    dir_display=${cwd/#$HOME/\~}
    parts+=("${c_dir}${dir_display}${c_reset}")
fi

# --- git: branch + dirty counts (skip optional locks — repo may be busy) ---
if [ -n "$cwd" ] && git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree &>/dev/null; then
    branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
    [ -z "$branch" ] && branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    [ -n "$branch" ] && parts+=("${c_git}git:${branch}${c_reset}")

    status_lines=$(git -C "$cwd" --no-optional-locks status --porcelain=v1 2>/dev/null)
    if [ -n "$status_lines" ]; then
        staged=$(grep -c '^[MADRC]' <<<"$status_lines")
        modified=$(grep -c '^.[MD]' <<<"$status_lines")
        untracked=$(grep -c '^??' <<<"$status_lines")
        dirty=""
        [ "$staged" -gt 0 ] && dirty="${dirty}+${staged} "
        [ "$modified" -gt 0 ] && dirty="${dirty}~${modified} "
        [ "$untracked" -gt 0 ] && dirty="${dirty}?${untracked}"
        dirty=$(echo "$dirty" | xargs)
        if [ -n "$dirty" ]; then
            parts+=("${c_dirty}${dirty}${c_reset}")
        else
            parts+=("${c_clean}clean${c_reset}")
        fi
    fi
fi

# --- worktree indicator: prefer Claude Code's own --worktree session,
# fall back to a plain git linked-worktree name ---
cc_worktree=$(echo "$input" | jq -r '.worktree.name // empty')
git_worktree=$(echo "$input" | jq -r '.workspace.git_worktree // empty')
if [ -n "$cc_worktree" ]; then
    parts+=("${c_wt}wt:${cc_worktree}${c_reset}")
elif [ -n "$git_worktree" ]; then
    parts+=("${c_wt}wt:${git_worktree}${c_reset}")
fi

# --- model + reasoning effort ---
model=$(echo "$input" | jq -r '.model.display_name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
if [ -n "$model" ]; then
    model_str="$model"
    [ -n "$effort" ] && model_str="${model_str}:${effort}"
    parts+=("${c_model}${model_str}${c_reset}")
fi

# --- context window usage (used_percentage is pre-calculated; null until
# the first API response of the session) ---
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
[ -n "$ctx_pct" ] && parts+=("${c_ctx}ctx:$(printf '%.0f' "$ctx_pct")%${c_reset}")

# --- session (5h) + weekly (7d) usage — native Claude.ai subscription limits,
# only present for subscribers after the first API response of the session ---
# resets_at is unix epoch seconds; both show as wall-clock time (5h omits
# the date, 7d includes it since it can be days out).
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

usage=""
if [ -n "$five_reset" ]; then
    five_fmt=$(date -d "@${five_reset}" '+%-I:%M%P' 2>/dev/null)
    five_label=$([ -n "$five_pct" ] && printf '%.0f%%' "$five_pct" || echo "5h")
    [ -n "$five_fmt" ] && usage="${five_label} (${five_fmt})"
fi
if [ -n "$week_reset" ]; then
    week_fmt_date=$(date -d "@${week_reset}" '+%b %-d, %-I:%M%P' 2>/dev/null)
    week_label=$([ -n "$week_pct" ] && printf '%.0f%%' "$week_pct" || echo "7d")
    if [ -n "$week_fmt_date" ]; then
        week_fmt="${week_label} (${week_fmt_date})"
        [ -n "$usage" ] && usage="${usage}${sep}${week_fmt}" || usage="$week_fmt"
    fi
fi
[ -n "$usage" ] && parts+=("${c_usage}${usage}${c_reset}")

c_remote=$'\033[2;96m'
esc=$'\033'
if [ -n "$CLAUDE_CODE_BRIDGE_SESSION_ID" ]; then
    # Using $esc ensures the terminal hyperlink sequences are evaluated immediately
    parts+=("${c_remote}rc:${esc}]8;;https://claude.ai/code/$CLAUDE_CODE_BRIDGE_SESSION_ID${esc}\\$CLAUDE_CODE_BRIDGE_SESSION_ID${esc}]8;;${esc}\\${c_reset}")
fi

out=""
for p in "${parts[@]}"; do
    if [ -z "$out" ]; then
        out="$p"
    else
        out="${out}${sep}${p}"
    fi
done

printf '%s\n' "$out"

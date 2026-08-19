#!/usr/bin/env bash
# Runs under bash (see settings.json statusLine) and zsh alike:
# no indexed arrays anywhere — bash is 0-based, zsh 1-based.
set -f
export LC_ALL=C   # deterministic date/tr output, independent of the user's locale

input=$(cat)

if [ -z "$input" ]; then
    printf "Claude"
    exit 0
fi

# ── Colors (real ESC bytes — output goes through %s, never %b) ──
esc=$'\033'
blue="${esc}[38;2;0;153;255m"
orange="${esc}[38;2;255;176;85m"
green="${esc}[38;2;0;175;80m"
cyan="${esc}[38;2;86;182;194m"
red="${esc}[38;2;255;85;85m"
yellow="${esc}[38;2;230;200;0m"
white="${esc}[38;2;220;220;220m"
magenta="${esc}[38;2;180;140;255m"
dim="${esc}[2m"
reset="${esc}[0m"

sep=" ${dim}│${reset} "

# ── Platform probe (once — avoids a failed date spawn per call) ──
if date --version >/dev/null 2>&1; then
    date_flavor=gnu
else
    date_flavor=bsd
fi

# ── Helpers ─────────────────────────────────────────────
is_int() {
    case "$1" in
        ''|*[!0-9]*) return 1 ;;
        *) return 0 ;;
    esac
}

# Round a decimal percentage to an integer. Anything non-numeric (null, "NaN",
# a string) yields empty, so callers never feed junk into an arithmetic test.
to_pct() {
    case "$1" in
        ''|*[!0-9.]*) return 1 ;;
    esac
    local n
    n=$(printf "%.0f" "$1" 2>/dev/null)
    is_int "$n" || return 1
    printf "%s" "$n"
}

color_for_pct() {
    local pct=$1
    is_int "$pct" || pct=0
    if [ "$pct" -ge 90 ]; then printf "%s" "$red"
    elif [ "$pct" -ge 70 ]; then printf "%s" "$yellow"
    elif [ "$pct" -ge 50 ]; then printf "%s" "$orange"
    else printf "%s" "$green"
    fi
}

build_bar() {
    local pct=$1
    local width=$2
    is_int "$pct" || pct=0
    [ "$pct" -lt 0 ] && pct=0
    [ "$pct" -gt 100 ] && pct=100

    local filled=$(( pct * width / 100 ))
    local empty=$(( width - filled ))
    local bar_color
    bar_color=$(color_for_pct "$pct")

    local filled_str="" empty_str=""
    for ((i=0; i<filled; i++)); do filled_str+="● "; done
    for ((i=0; i<empty; i++)); do empty_str+="○ "; done

    printf "%s" "${bar_color}${filled_str}${dim}${empty_str}${reset}"
}

format_epoch_time() {
    local epoch=$1
    local style=$2
    is_int "$epoch" || return
    [ "$epoch" = "0" ] && return

    local fmt result=""
    case "$style" in
        time)     fmt="%l:%M%p" ;;
        datetime) fmt="%b %-d, %l:%M%p" ;;
        *)        fmt="%b %-d" ;;
    esac

    if [ "$date_flavor" = gnu ]; then
        result=$(date -d "@$epoch" +"$fmt" 2>/dev/null)
    else
        result=$(date -j -r "$epoch" +"$fmt" 2>/dev/null)
    fi

    result=$(echo "$result" | sed 's/  / /g; s/^ //; s/\.//g' | tr '[:upper:]' '[:lower:]')
    printf "%s" "$result"
}

# Accepts either a unix epoch or an ISO-8601 timestamp; prints an epoch.
to_epoch() {
    local v="$1"
    [ -z "$v" ] || [ "$v" = "null" ] && return 1

    if is_int "$v"; then
        printf "%s" "$v"
        return 0
    fi

    local epoch=""
    if [ "$date_flavor" = gnu ]; then
        epoch=$(date -d "$v" +%s 2>/dev/null)
    else
        local stripped="${v%%.*}"
        stripped="${stripped%%Z}"
        stripped="${stripped%%+*}"
        stripped="${stripped%%-[0-9][0-9]:[0-9][0-9]}"
        if [[ "$v" == *"Z"* ]] || [[ "$v" == *"+00:00"* ]] || [[ "$v" == *"-00:00"* ]]; then
            epoch=$(env TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
        else
            epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
        fi
    fi

    is_int "$epoch" || return 1
    printf "%s" "$epoch"
}

# Age of a file (or dir) in seconds; prints nothing if it cannot be stat'd.
file_age() {
    local mtime
    mtime=$(stat -c %Y "$1" 2>/dev/null || stat -f %m "$1" 2>/dev/null)
    is_int "$mtime" || return 1
    printf "%s" $(( $(date +%s) - mtime ))
}

# extra_usage lives only in the API payload; parse it from JSON on stdin.
parse_extra_usage() {
    local out
    out=$(jq -r '
        def s: if . == null then "" else (. | tostring) end;
        [ (.extra_usage.is_enabled // false),
          .extra_usage.utilization,
          .extra_usage.used_credits,
          .extra_usage.monthly_limit
        ] | map(s) | .[]
    ' 2>/dev/null)
    extra_enabled=""; extra_utilization=""; extra_used_raw=""; extra_limit_raw=""
    {
        IFS= read -r extra_enabled
        IFS= read -r extra_utilization
        IFS= read -r extra_used_raw
        IFS= read -r extra_limit_raw
    } <<__SL_FIELDS__
$out
__SL_FIELDS__
    [ -z "$extra_enabled" ] && extra_enabled="false"
}

# ── Extract every stdin field in ONE jq call ────────────
raw=$(printf '%s' "$input" | jq -r '
    def s: if . == null then "" else (. | tostring | gsub("[\n\t]"; " ")) end;
    [ (.model.display_name // "Claude"),
      (.model.id // ""),
      (.cwd // ""),
      .context_window.used_percentage,
      .context_window.current_usage.input_tokens,
      .context_window.current_usage.cache_creation_input_tokens,
      .context_window.current_usage.cache_read_input_tokens,
      .context_window.context_window_size,
      .cost.total_duration_ms,
      .effort.level,
      .worktree.name,
      .workspace.git_worktree,
      .remote.session_id,
      .rate_limits.five_hour.used_percentage,
      .rate_limits.five_hour.resets_at,
      .rate_limits.seven_day.used_percentage,
      .rate_limits.seven_day.resets_at
    ] | map(s) | .[]
' 2>/dev/null)

{
    IFS= read -r model_name
    IFS= read -r model_id
    IFS= read -r cwd
    IFS= read -r ctx_pct_raw
    IFS= read -r ctx_input
    IFS= read -r ctx_cache_create
    IFS= read -r ctx_cache_read
    IFS= read -r ctx_window_size
    IFS= read -r duration_ms
    IFS= read -r effort
    IFS= read -r cc_worktree
    IFS= read -r git_worktree
    IFS= read -r remote_session_id
    IFS= read -r stdin_five_pct
    IFS= read -r stdin_five_reset
    IFS= read -r stdin_seven_pct
    IFS= read -r stdin_seven_reset
} <<__SL_FIELDS__
$raw
__SL_FIELDS__

[ -z "$model_name" ] && model_name="Claude"

# Effort: stdin is authoritative (tracks /effort and permission layers);
# settings.json is only a fallback for older clients.
if [ -z "$effort" ]; then
    settings_path="$HOME/.claude/settings.json"
    if [ -f "$settings_path" ]; then
        effort=$(jq -r '.effortLevel // empty' "$settings_path" 2>/dev/null)
    fi
fi
[ -z "$effort" ] && effort="default"

# ── Context window % ────────────────────────────────────
ctx_pct=$(to_pct "$ctx_pct_raw")
if [ -z "$ctx_pct" ] && is_int "$ctx_window_size" && [ "$ctx_window_size" -gt 0 ]; then
    is_int "$ctx_input" || ctx_input=0
    is_int "$ctx_cache_create" || ctx_cache_create=0
    is_int "$ctx_cache_read" || ctx_cache_read=0
    ctx_pct=$(( (ctx_input + ctx_cache_create + ctx_cache_read) * 100 / ctx_window_size ))
fi

# ── LINE 1: model:effort │ ctx: │ dir: │ git: │ wt: │ act: │ rc: ──
[ -z "$cwd" ] && cwd=$(pwd)
dirname=$(basename "$cwd")

branch_max=20

git_branch=""
git_dirty=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
    # detached HEAD: fall back to the short SHA so the dirty marker survives
    [ -z "$git_branch" ] && git_branch="@$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)"
    [ "$git_branch" = "@" ] && git_branch=""

    # keep a long branch from pushing the rest of line 1 off a narrow pane
    if [ ${#git_branch} -gt "$branch_max" ]; then
        git_branch="${git_branch:0:$((branch_max - 1))}…"
    fi

    # -uno: skips the untracked-file walk (26ms -> 5ms in a large monorepo).
    # Trade-off: a brand-new untracked file no longer lights the dirty marker.
    git_status=$(git -C "$cwd" --no-optional-locks status --porcelain -uno 2>/dev/null)
    if [ -n "$git_status" ]; then
        # the porcelain output is already in hand; counting it costs nothing
        git_dirty="*$(printf '%s\n' "$git_status" | wc -l | tr -d ' ')"
    fi
fi

session_duration=""
if is_int "$duration_ms"; then
    elapsed=$(( duration_ms / 1000 ))
    [ "$elapsed" -lt 0 ] && elapsed=0
    if [ "$elapsed" -ge 3600 ]; then
        session_duration="$(( elapsed / 3600 ))h$(( (elapsed % 3600) / 60 ))m"
    elif [ "$elapsed" -ge 60 ]; then
        session_duration="$(( elapsed / 60 ))m"
    else
        session_duration="${elapsed}s"
    fi
fi

# <model.id>:<effort.level>, e.g. claude-opus-5:high
model_label="${model_id:-$model_name}"
line1="${blue}${model_label}${reset}"
case "$effort" in
    high)   effort_color="$magenta" ;;
    medium) effort_color="$white" ;;
    *)      effort_color="$dim" ;;
esac
[ -n "$effort" ] && line1+="${dim}:${reset}${effort_color}${effort}${reset}"

if [ -n "$ctx_pct" ]; then
    ctx_color=$(color_for_pct "$ctx_pct")
    line1+="${sep}${dim}ctx:${reset}${ctx_color}${ctx_pct}%${reset}"
fi

line1+="${sep}${dim}dir:${reset}${cyan}${dirname}${reset}"
if [ -n "$git_branch" ]; then
    line1+="${sep}${dim}git:${reset}${green}${git_branch}${reset}${red}${git_dirty}${reset}"
fi

# --- worktree indicator: prefer Claude Code's own --worktree session,
# fall back to a plain git linked-worktree name ---
if [ -n "$cc_worktree" ]; then
    line1+="${sep}${yellow}wt:${cc_worktree}${reset}"
elif [ -n "$git_worktree" ]; then
    line1+="${sep}${yellow}wt:${git_worktree}${reset}"
fi

if [ -n "$session_duration" ]; then
    line1+="${sep}"
    line1+="${dim}act:${reset}${white}${session_duration}${reset}"
fi
bridge_session="${remote_session_id:-$CLAUDE_CODE_BRIDGE_SESSION_ID}"
if [ -n "$bridge_session" ]; then
    st="${esc}\\"
    line1+="${sep}rc:${esc}]8;;https://claude.ai/code/${bridge_session}${st}${bridge_session}${esc}]8;;${st}"
fi

# ── Rate limits from stdin (primary) ───────────────────
has_stdin_rates=false
five_hour_pct=""
five_hour_reset_epoch=""
seven_day_pct=""
seven_day_reset_epoch=""

if [ -n "$stdin_five_pct" ] || [ -n "$stdin_seven_pct" ]; then
    has_stdin_rates=true
    five_hour_pct=$(to_pct "$stdin_five_pct")
    five_hour_reset_epoch=$(to_epoch "$stdin_five_reset")
    seven_day_pct=$(to_pct "$stdin_seven_pct")
    seven_day_reset_epoch=$(to_epoch "$stdin_seven_reset")
fi

# ── Usage cache (refreshed out of band — never on the render path) ──
cache_dir="${XDG_RUNTIME_DIR:-$HOME/.cache}/claude"
cache_file="$cache_dir/statusline-usage-cache.json"
lock_dir="$cache_dir/.refresh.lock"
cache_max_age=60
cache_stale_age=900
lock_max_age=30

usage_data=""
usage_age=""
extra_enabled="false"

# Fetch usage into the cache. Only ever called detached, so a slow or hanging
# api.anthropic.com can never stall the prompt.
refresh_usage_cache() {
    local token="" blob creds_file response tmp

    if [ -n "$CLAUDE_CODE_OAUTH_TOKEN" ]; then
        token="$CLAUDE_CODE_OAUTH_TOKEN"
    elif command -v security >/dev/null 2>&1; then
        blob=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
        [ -n "$blob" ] && token=$(printf '%s' "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
    fi
    if [ -z "$token" ]; then
        creds_file="${HOME}/.claude/.credentials.json"
        [ -f "$creds_file" ] && token=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds_file" 2>/dev/null)
    fi
    if [ -z "$token" ] && command -v secret-tool >/dev/null 2>&1; then
        blob=$(timeout 2 secret-tool lookup service "Claude Code-credentials" 2>/dev/null)
        [ -n "$blob" ] && token=$(printf '%s' "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
    fi
    [ -z "$token" ] && return 1

    # Headers arrive via -K on stdin: the bearer token never appears in argv,
    # where any local process could read it out of ps(1).
    response=$(curl -s --max-time 5 -K - "https://api.anthropic.com/api/oauth/usage" <<CURL_CFG
header = "Accept: application/json"
header = "Content-Type: application/json"
header = "Authorization: Bearer ${token}"
header = "anthropic-beta: oauth-2025-04-20"
header = "User-Agent: claude-code/2.1.34"
CURL_CFG
)
    [ -n "$response" ] || return 1
    printf '%s' "$response" | jq -e '.five_hour' >/dev/null 2>&1 || return 1

    # Write then rename, so a reader never catches a half-written cache.
    tmp="${cache_file}.$$"
    ( umask 077; printf '%s' "$response" > "$tmp" ) 2>/dev/null || return 1
    mv -f "$tmp" "$cache_file" 2>/dev/null
}

if ! $has_stdin_rates; then
    usage_age=$(file_age "$cache_file")

    if [ -z "$usage_age" ] || [ "$usage_age" -ge "$cache_max_age" ]; then
        lock_age=$(file_age "$lock_dir")
        if is_int "$lock_age" && [ "$lock_age" -ge "$lock_max_age" ]; then
            rmdir "$lock_dir" 2>/dev/null      # previous refresh died holding it
        fi
        mkdir -p -m 700 "$cache_dir" 2>/dev/null
        # mkdir is the atomic lock: concurrent renders spawn exactly one fetch.
        if mkdir "$lock_dir" 2>/dev/null; then
            # stdout/stderr detached, or Claude Code would wait on the inherited
            # pipe for as long as curl runs — which is the stall we just removed.
            ( refresh_usage_cache; rmdir "$lock_dir" 2>/dev/null ) >/dev/null 2>&1 </dev/null &
        fi
    fi

    [ -f "$cache_file" ] && usage_data=$(cat "$cache_file" 2>/dev/null)

    if [ -n "$usage_data" ] && printf '%s' "$usage_data" | jq -e . >/dev/null 2>&1; then
        usage_fields=$(printf '%s' "$usage_data" | jq -r '
            def s: if . == null then "" else (. | tostring) end;
            [ .five_hour.utilization,
              .five_hour.resets_at,
              .seven_day.utilization,
              .seven_day.resets_at
            ] | map(s) | .[]
        ' 2>/dev/null)
        u_five_pct=""; u_five_reset=""; u_seven_pct=""; u_seven_reset=""
        {
            IFS= read -r u_five_pct
            IFS= read -r u_five_reset
            IFS= read -r u_seven_pct
            IFS= read -r u_seven_reset
        } <<__SL_FIELDS__
$usage_fields
__SL_FIELDS__

        five_hour_pct=$(to_pct "$u_five_pct")
        five_hour_reset_epoch=$(to_epoch "$u_five_reset")
        seven_day_pct=$(to_pct "$u_seven_pct")
        seven_day_reset_epoch=$(to_epoch "$u_seven_reset")
        printf '%s' "$usage_data" | parse_extra_usage
    fi
else
    # stdin covers the rate limits, so nothing refreshes the cache here. Reuse it
    # for the extra-usage line only while it is fresh — never show stale dollars.
    extra_age=$(file_age "$cache_file")
    if is_int "$extra_age" && [ "$extra_age" -lt "$cache_stale_age" ]; then
        parse_extra_usage < "$cache_file"
    fi
fi

# ── Rate limit lines ────────────────────────────────────
rate_lines=""
bar_width=10

stale_note=""
if ! $has_stdin_rates && is_int "$usage_age" && [ "$usage_age" -ge "$cache_stale_age" ]; then
    stale_note=" ${dim}~$(( usage_age / 60 ))m old${reset}"
fi

if [ -n "$five_hour_pct" ]; then
    five_hour_reset=$(format_epoch_time "$five_hour_reset_epoch" "time")
    five_hour_bar=$(build_bar "$five_hour_pct" "$bar_width")
    five_hour_pct_color=$(color_for_pct "$five_hour_pct")
    five_hour_pct_fmt=$(printf "%3d" "$five_hour_pct")

    rate_lines+="${white}current${reset} ${five_hour_bar} ${five_hour_pct_color}${five_hour_pct_fmt}%${reset}"
    [ -n "$five_hour_reset" ] && rate_lines+=" ${dim}⟳${reset} ${white}${five_hour_reset}${reset}"
    rate_lines+="${stale_note}"
fi

if [ -n "$seven_day_pct" ]; then
    seven_day_reset=$(format_epoch_time "$seven_day_reset_epoch" "datetime")
    seven_day_bar=$(build_bar "$seven_day_pct" "$bar_width")
    seven_day_pct_color=$(color_for_pct "$seven_day_pct")
    seven_day_pct_fmt=$(printf "%3d" "$seven_day_pct")

    [ -n "$rate_lines" ] && rate_lines+=$'\n'
    rate_lines+="${white}weekly${reset}  ${seven_day_bar} ${seven_day_pct_color}${seven_day_pct_fmt}%${reset}"
    [ -n "$seven_day_reset" ] && rate_lines+=" ${dim}⟳${reset} ${white}${seven_day_reset}${reset}"
fi

if [ "$extra_enabled" = "true" ] && [ -n "$extra_used_raw" ] && [ -n "$extra_limit_raw" ]; then
    extra_pct=$(to_pct "$extra_utilization")
    [ -z "$extra_pct" ] && extra_pct=0
    extra_fmt=$(awk -v u="$extra_used_raw" -v l="$extra_limit_raw" \
        'BEGIN { printf "%.2f\n%.2f", u/100, l/100 }')
    {
        IFS= read -r extra_used
        IFS= read -r extra_limit
    } <<__SL_FIELDS__
$extra_fmt
__SL_FIELDS__
    extra_bar=$(build_bar "$extra_pct" "$bar_width")
    extra_pct_color=$(color_for_pct "$extra_pct")

    if [ "$date_flavor" = gnu ]; then
        extra_reset=$(date -d "$(date +%Y-%m-01) +1 month" +"%b %-d" 2>/dev/null | tr '[:upper:]' '[:lower:]')
    else
        extra_reset=$(date -v+1m -v1d +"%b %-d" 2>/dev/null | tr '[:upper:]' '[:lower:]')
    fi

    [ -n "$rate_lines" ] && rate_lines+=$'\n'
    rate_lines+="${white}extra${reset}   ${extra_bar} ${extra_pct_color}\$${extra_used}${dim}/${reset}${white}\$${extra_limit}${reset} ${dim}⟳${reset} ${white}${extra_reset}${reset}"
fi

# ── Output ──────────────────────────────────────────────
printf '%s' "$line1"
[ -n "$rate_lines" ] && printf '\n\n%s' "$rate_lines"

exit 0

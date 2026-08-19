#!/usr/bin/env bash
# Runs under bash (see settings.json statusLine) and zsh alike:
# no indexed arrays anywhere — bash is 0-based, zsh 1-based.
set -f
export LC_ALL=C   # deterministic date/tr output, independent of the user's locale

input=$(cat)

if [ -z "$input" ]; then
    printf "Gemini"
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

# ── Extract fields in ONE jq call ───────────────────────
raw=$(printf '%s' "$input" | jq -r '
    def s: if . == null then "" else (. | tostring | gsub("[\n\t]"; " ")) end;
    [ (.model.display_name // .model.displayName // .model.name // .model.id // .model),
      .model.id,
      (.cwd // .workspace.current_dir // .workspace.project_dir),
      .context_window.used_percentage,
      .context_window.current_usage.input_tokens,
      .context_window.current_usage.cache_creation_input_tokens,
      .context_window.current_usage.cache_read_input_tokens,
      .context_window.context_window_size,
      .cost.total_duration_ms,
      .session.start_time,
      .effort.level,
      .vcs.branch,
      (if .vcs.dirty == true then "*" elif .vcs.dirty == false then "" else (.vcs.dirty // "") end),
      .workspace.git_worktree
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
    IFS= read -r session_start
    IFS= read -r effort
    IFS= read -r vcs_branch
    IFS= read -r vcs_dirty
    IFS= read -r git_worktree
} <<__SL_FIELDS__
$raw
__SL_FIELDS__

[ -z "$model_name" ] && model_name="Gemini"

# Effort: stdin is authoritative (tracks /effort and permission layers);
# settings.json is only a fallback.
if [ -z "$effort" ]; then
    s_path="$HOME/.gemini/antigravity-cli/settings.json"
    if [ -f "$s_path" ]; then
        effort=$(jq -r '.effortLevel // empty' "$s_path" 2>/dev/null)
    fi
fi

model_label="${model_name:-$model_id}"

# Extract effort from model name suffix if not yet determined (e.g. "Gemini 3.7 Flash (High)")
if [ -z "$effort" ]; then
    case "$model_label" in
        *\([Hh]igh\)*)   effort="high" ;;
        *\([Mm]edium\)*) effort="medium" ;;
        *\([Ll]ow\)*)    effort="low" ;;
    esac
fi

# Strip effort suffix from model_label for clean display: "Gemini 3.7 Flash (High)" -> "Gemini 3.7 Flash"
model_label=$(printf '%s' "$model_label" | sed -E 's/ *\((High|Medium|Low|high|medium|low)\)//g')

[ -z "$effort" ] && effort="default"

# ── Context window % ────────────────────────────────────
ctx_pct=$(to_pct "$ctx_pct_raw")
if [ -z "$ctx_pct" ] && is_int "$ctx_window_size" && [ "$ctx_window_size" -gt 0 ]; then
    is_int "$ctx_input" || ctx_input=0
    is_int "$ctx_cache_create" || ctx_cache_create=0
    is_int "$ctx_cache_read" || ctx_cache_read=0
    ctx_pct=$(( (ctx_input + ctx_cache_create + ctx_cache_read) * 100 / ctx_window_size ))
fi

# ── LINE 1: model:effort │ ctx: │ dir: │ git: │ wt: │ act: ──
[ -z "$cwd" ] && cwd=$(pwd)
dirname=$(basename "$cwd")

branch_max=20
git_branch="$vcs_branch"
git_dirty="$vcs_dirty"

if [ -z "$git_branch" ] && git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
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
elif [ -n "$git_branch" ]; then
    if [ ${#git_branch} -gt "$branch_max" ]; then
        git_branch="${git_branch:0:$((branch_max - 1))}…"
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
elif [ -n "$session_start" ]; then
    start_epoch=$(to_epoch "$session_start")
    if is_int "$start_epoch"; then
        now_epoch=$(date +%s)
        elapsed=$(( now_epoch - start_epoch ))
        [ "$elapsed" -lt 0 ] && elapsed=0
        if [ "$elapsed" -ge 3600 ]; then
            session_duration="$(( elapsed / 3600 ))h$(( (elapsed % 3600) / 60 ))m"
        elif [ "$elapsed" -ge 60 ]; then
            session_duration="$(( elapsed / 60 ))m"
        else
            session_duration="${elapsed}s"
        fi
    fi
fi

# <model_label>:<effort.level>, e.g. Gemini 3.7 Flash:high
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

if [ -n "$git_worktree" ]; then
    line1+="${sep}${yellow}wt:${git_worktree}${reset}"
fi

if [ -n "$session_duration" ]; then
    line1+="${sep}"
    line1+="${dim}act:${reset}${white}${session_duration}${reset}"
fi

# ── Quota & Rate limits (current session / 5h and weekly only) ──
rate_lines1=""
bar_width=10

quota_data=$(printf '%s' "$input" | jq -r '
    (.model.display_name // .model.displayName // .model.name // .model.id // "Gemini") as $model_raw |

    (if ($model_raw | test("claude|sonnet|anthropic"; "i")) then {family: "Claude", prefix: "3p|claude|anthropic"}
     elif ($model_raw | test("gpt|openai"; "i")) then {family: "GPT", prefix: "3p|openai|gpt"}
     elif ($model_raw | test("gemini"; "i")) then {family: "Gemini", prefix: "gemini"}
     else {family: ($model_raw | split(" ")[0]), prefix: "gemini|3p"}
     end) as $m |

    (.quota // {}) as $q |

    ([ $q | to_entries[]? | select(.key | test($m.prefix; "i")) | select(.key | test("3p"; "i") | not) ] |
     if length > 0 then . else [ $q | to_entries[]? | select(.key | test("3p"; "i") | not) ] end) as $entries |

    # 3p-specific entries (quota keys containing "3p" with "5h" or "week")
    ([ $q | to_entries[]? | select(.key | test("3p"; "i")) ]) as $entries_3p |

    [
        ([ $entries[] | select(.key | test("current|5h|five|session"; "i")) ][0] // empty | {
            label: "current",
            pct: (if .value.used_percentage != null then .value.used_percentage
                  elif .value.remaining_percentage != null then (100 - .value.remaining_percentage)
                  elif .value.remaining_fraction != null then ((1 - .value.remaining_fraction) * 100)
                  elif .value.used_fraction != null then (.value.used_fraction * 100)
                  else "" end),
            reset_time: (.value.reset_time // ""),
            reset_sec: (.value.reset_in_seconds // ""),
            is_session: "true"
        }),
        ([ $entries[] | select(.key | test("week|7d|seven"; "i")) ][0] // empty | {
            label: "weekly",
            pct: (if .value.used_percentage != null then .value.used_percentage
                  elif .value.remaining_percentage != null then (100 - .value.remaining_percentage)
                  elif .value.remaining_fraction != null then ((1 - .value.remaining_fraction) * 100)
                  elif .value.used_fraction != null then (.value.used_fraction * 100)
                  else "" end),
            reset_time: (.value.reset_time // ""),
            reset_sec: (.value.reset_in_seconds // ""),
            is_session: "false"
        }),
        ([ $entries_3p[] | select(.key | test("5h|current|five|session"; "i")) ][0] // empty | {
            label: "current (3p)",
            pct: (if .value.used_percentage != null then .value.used_percentage
                  elif .value.remaining_percentage != null then (100 - .value.remaining_percentage)
                  elif .value.remaining_fraction != null then ((1 - .value.remaining_fraction) * 100)
                  elif .value.used_fraction != null then (.value.used_fraction * 100)
                  else "" end),
            reset_time: (.value.reset_time // ""),
            reset_sec: (.value.reset_in_seconds // ""),
            is_session: "true"
        }),
        ([ $entries_3p[] | select(.key | test("week|7d|seven"; "i")) ][0] // empty | {
            label: "weekly (3p)",
            pct: (if .value.used_percentage != null then .value.used_percentage
                  elif .value.remaining_percentage != null then (100 - .value.remaining_percentage)
                  elif .value.remaining_fraction != null then ((1 - .value.remaining_fraction) * 100)
                  elif .value.used_fraction != null then (.value.used_fraction * 100)
                  else "" end),
            reset_time: (.value.reset_time // ""),
            reset_sec: (.value.reset_in_seconds // ""),
            is_session: "false"
        })
    ] | .[]? | [ .label, (.pct | tostring), .reset_time, (.reset_sec | tostring), .is_session ] | join("|")
' 2>/dev/null)

if [ -n "$quota_data" ]; then
    while IFS='|' read -r q_label q_pct_raw q_reset_time q_reset_sec is_session; do
        [ -z "$q_label" ] && continue
        pct=$(to_pct "$q_pct_raw")
        [ -z "$pct" ] && continue

        reset_epoch=""
        if [ -n "$q_reset_time" ]; then
            reset_epoch=$(to_epoch "$q_reset_time")
        fi
        if [ -z "$reset_epoch" ] && is_int "$q_reset_sec"; then
            now_epoch=$(date +%s)
            reset_epoch=$(( now_epoch + q_reset_sec ))
        fi

        reset_str=""
        if is_int "$reset_epoch"; then
            now_epoch=$(date +%s)
            if [ "$is_session" = "true" ] && [ "$reset_epoch" -gt "$now_epoch" ] && [ $(( reset_epoch - now_epoch )) -le 86400 ]; then
                reset_str=$(format_epoch_time "$reset_epoch" "time")
            else
                reset_str=$(format_epoch_time "$reset_epoch" "datetime")
            fi
        fi

        bar=$(build_bar "$pct" "$bar_width")
        pct_color=$(color_for_pct "$pct")
        pct_fmt=$(printf "%3d" "$pct")
        label_fmt=$(printf "%-14s" "$q_label")

        [ -n "$rate_lines1" ] && rate_lines1+=$'\n'
        rate_lines1+="${white}${label_fmt}${reset} ${bar} ${pct_color}${pct_fmt}%${reset}"
        [ -n "$reset_str" ] && rate_lines1+=" ${dim}⟳${reset} ${white}${reset_str}${reset}"
    done <<< "$quota_data"
fi

# ── Output ──────────────────────────────────────────────
printf '%s' "$line1"
[ -n "$rate_lines1" ] && printf '\n%s' "$rate_lines1"

exit 0

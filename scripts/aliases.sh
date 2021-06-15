#!/usr/bin/env bash
# linting via shellcheck
# shellcheck disable=SC2096

# Exit on error. Append "|| true" if you expect an error.
# set -o errexit
# # Exit on error inside any functions or subshells.
# set -o errtrace
# # Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
# set -o nounset
# # Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
# set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

#  ██████╗ ██╗████████╗
# ██╔════╝ ██║╚══██╔══╝
# ██║  ███╗██║   ██║
# ██║   ██║██║   ██║
# ╚██████╔╝██║   ██║
#  ╚═════╝ ╚═╝   ╚═╝

# shellcheck disable=SC2034
branch() {
    git rev-parse --abbrev-ref HEAD
}

gsm() {
    git submodule foreach --recursive git "$@"

    echo -e '\n\e[32m\e[1mExecuted:\e[0m git submodule foreach --recursive git' "$@" '\n'
}

stash-explore() {
    # git stash list | cut -d \  -f1 | grep -Eo 'stash@{[0-9]{1,}}' | fzf --reverse --preview-window=70% --preview 'git stash show -p {} | diff-so-fancy'
    # git stash list |
    #    fzf --reverse --preview-window=70% --preview 'bat -l diff <<< $(git stash show -p $(echo {} | grep -Eo "stash@{[0-9]{1,}}"))' |
    #    grep --color=none -Eo 'stash@{[0-9]{1,}}'
    git stash list | cut -d \  -f1 | grep -Eo 'stash@{[0-9]{1,}}' | fzf --reverse --preview-window=70% --preview 'bat --color=always <<< `git stash show -p {}`'
}

clean-git-branches() {
    git branch | grep -E -v "(^\s+dev$|^\s+master|^\*.+$)" | xargs --no-run-if-empty git branch -D
}

# gcp - git commit with previews
gcp() {
    local _gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    local _viewGitLogLine="$_gitLogLineToHash | xargs --no-run-if-empty -I % sh -c"
    local differ="git show --color=always %"

    if command -v &> /dev/null; then
        differ=" | diff-so-fancy"
    fi

    git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@" | fzf --no-sort --reverse --tiebreak=index --no-multi --ansi --preview "$_viewGitLogLine '$differ'"
}

qs() {
    BRANCH=$(shuf /usr/share/dict/words -n 1 | sed "s/'//g")
    git checkout -b "wip/${BRANCH}"
}

# ██╗   ██╗████████╗██╗██╗     ██╗████████╗██╗███████╗███████╗
# ██║   ██║╚══██╔══╝██║██║     ██║╚══██╔══╝██║██╔════╝██╔════╝
# ██║   ██║   ██║   ██║██║     ██║   ██║   ██║█████╗  ███████╗
# ██║   ██║   ██║   ██║██║     ██║   ██║   ██║██╔══╝  ╚════██║
# ╚██████╔╝   ██║   ██║███████╗██║   ██║   ██║███████╗███████║
#  ╚═════╝    ╚═╝   ╚═╝╚══════╝╚═╝   ╚═╝   ╚═╝╚══════╝╚══════╝

# Get running process that matches the passed argument
# If none provided, will show all running processes.
po() {
    # shellcheck disable=SC2009
    ps -aef | grep -i "$1"
}

# String comparison
comp_str() {
    if [[ $1 == "$2" ]]; then
        echo 'Matched!'
    else
        echo "$1" "&" "$2" 'does not match!'
    fi
}

# Expand URL
check-url() {
    curl -sI "$1" | sed -n 's/Location: *//p'
}

# Mini calculator
calc() {
    if [[ $SHELL =~ 'zsh' ]]; then
        set -o noglob
    elif [[ $SHELL =~ 'bash' ]]; then
        set -o localoptions -o noglob
    fi

    echo Answer: "$(echo "scale=3; $*" | /usr/bin/bc -l)"
}

# Either check for internet connectivity or does speedtest
st() {
    if [ -z "$*" ]; then
        ping -c 3 google.com
    else
        speedtest-cli --bytes --no-upload
    fi
}

# restart network manager
rnet() {
    distro=$(lsb_release -i | column -t | cut -d\  -f5 | tr '[:upper:]' '[:lower:]')

    case $distro in
        manjarolinux)
            sudo -k systemctl restart NetworkManager.service
            ;;

        ubuntu)
            sudo -k service network-manager restart
            ;;
    esac
}

t() {
    # GREP for string provided by user in a
    # user defined or predefined directory
    # First parameter string to search for
    # Second parameter path to search in

    # Exit if no/whitespace search string provided, exit.
    # There's no point continuing.
    if [[ -z $1 ]]; then
        echo 'Required argument not provided, exiting...'
        exit 1
    fi

    local DEFAULT_DIR=src/scripts/

    GREP_ME() {
        grep -E --exclude="yarn.lock" --exclude-dir={.git,node_modules,bower_components,out,vendor,flow-typed,build,coverage} -irHn --color=auto "$1" "$2"
    }

    if [[ -z $2 ]]; then
        if [[ -d $DEFAULT_DIR ]]; then
            GREP_ME "$1" "$(pwd)/$DEFAULT_DIR"
        else
            GREP_ME "$1" "$(pwd)"
        fi
    else
        GREP_ME "$1" "$(pwd)/$2"
    fi
}

fkill() {
    # shellcheck disable=SC2155
    local PID=$(
        ps -aux |
            sed 1d |
            fzf --sync \
                --border \
                --prompt='⚙ ' \
                --reverse \
                --multi \
                --preview 'echo {} | column -t | cut -d\  -f 3 | xargs --no-run-if-empty pstree -h ' |
            awk '{print $2}'
    )

    [[ -n $PID ]] && echo "$PID" | xargs --no-run-if-empty kill -SIGTERM
}

fzf:preview:file() {
    rg --files | fzf --reverse --preview 'bat --color=always {}'
}

fzf:grep() {
    # local xxx="echo {} | egrep -io '^\\|\..+:' | xargs -I % sh -c 'cat'"

    # shellcheck disable=SC2155
    local match=$(grep -r -nEHI '[[:alnum:]]' "." --exclude="yarn.lock" --exclude-dir={.git,node_modules,bower_components,out,vendor,flow-typed} | fzf --reverse --cycle)

    if [[ -n $match ]]; then
        local file
        local line

        IFS=: read -r file line _ <<< "$match"

        # subl "$file":"$line" < /dev/tty
        code --goto "$file":"$line" < /dev/tty
    fi
}

npm-scripts() {
    local script

    if command -v jq &> /dev/null; then
        script=$(jq --monochrome-output --raw-output '.scripts | keys[]' package.json | fzf --reverse)
    else
        script=$(node -e "try { Object.keys(require('./package.json').scripts).forEach(script => console.log(script)) } catch {}" | fzf --reverse)
    fi

    local pkg_man_with_cmd="npm run"

    if [ -f yarn.lock ]; then
        pkg_man_with_cmd="yarn"
    fi

    if [ -n "$script" ]; then
        echo "$(tput setaf 11) $pkg_man_with_cmd $script$(tput sgr0)"
        sh -c "$pkg_man_with_cmd $script"
    fi
}

serve() {
    if [[ $(python -V) == Python[[:space:]]3.* ]]; then
        python -m http.server
    elif [[ $(python -V) == Python[[:space:]]2.* ]]; then
        python -m SimpleHTTPServer
    fi
}

d() {
    # history -1 | fzf --tac --bind 'enter:execute(echo {} | sed -r "s/ *[0-9]*\*? *//")+abort'
    print -z "$(history -1 | fzf --reverse --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')"
}

print-colors() {
    for i in {0..256}; do
        printf "%s %s" "$(tput setaf "$i")" "$i"
        [[ $i == 256 ]] && echo
    done
}

man2pdf() {
    local DEST=${2:-$HOME/Documents}

    if command man -w "$1" 1> /dev/null; then
        command man -Tpdf "$1" > "$DEST/$1.pdf"

        printf "'%s' saved in '%s' \n" "$1.pdf" "$DEST"
    fi
}

update-pkgs() {
    if \command -v yay &> /dev/null; then
        yay -Syu --noconfirm

    elif \command -v paru &> /dev/null; then
        paru -Syu --noconfirm
    fi

    if \command -v snap &> /dev/null; then
        sudo snap refresh
    fi

    if \command -v flatpak &> /dev/null; then
        flatpak update --noninteractive
    fi
}

purge-pkgs() {
    if \command -v flatpak &> /dev/null; then
        flatpak uninstall --unused
    fi

    if \command -v snap &> /dev/null; then
        snap list --all | while read -r snapname _ rev _ _ notes; do
            if [[ $notes == *disabled* ]]; then
                sudo snap remove "$snapname" --revision="$rev"
            fi
        done
    fi

    if \command -v pacman &> /dev/null; then
        sudo pacman -Rnsc $(pacman -Qttdq)
    fi
}

rscript() {
    temp_file=$(mktemp)

    cat << EOF > "$temp_file"
fn main() {
    $1;
}
EOF

    new_temp=$(mktemp)

    # rustc --verbose -C opt-level=z -C panic=abort -C lto -C codegen-units=1 "$temp_file" -o "$new_temp"
    rustc "$temp_file" -o "$new_temp"

    (cd /tmp && "$new_temp")

    rm "$temp_file" "$new_temp"
}

alias bat='bat --color=always'
alias c='git status'
alias df='df -h'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias free='free -mhtw'
alias gc='git checkout '
alias gd='git diff '
alias gh='history | grep'
alias gi='git commit -am '
alias gl='git log --pretty=format:"%C(bold cyan)%s %C(red)(%h)%Creset%n%C(magenta)%b%n%C(yellow)%cr by %an%Creset" --stat'
alias gll="git log --pretty=format:'%Cred%h%Creset -%C(white bold) %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gp='git pull origin $(branch)'
alias gps='git push origin $(branch)'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto -hls'
alias more=less
alias open='xdg-open'
alias v='git branch -vv'

if command -v xclip &> /dev/null; then
    alias xcopy='xclip -in -selection clipboard'
    alias xpaste='xclip -out -selection clipboard'
fi

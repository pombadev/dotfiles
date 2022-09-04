#!/usr/bin/env bash

setting="${0%/*}/.argos-netspeed-setting"

DEVICE=$(<"$setting")
DEVICE=${DEVICE:-all}

declare INSPEED
declare OUTSPEED

updateUpDown() {
    local LINE
    local RECEIVED_OLD
    local TRANSMITTED_OLD
    local RECEIVED_NEW
    local TRANSMITTED_NEW

    LINE=$(grep "$1" /proc/net/dev | sed s/.*://)
    RECEIVED_OLD=$(echo "$LINE" | awk '{print $1}')
    TRANSMITTED_OLD=$(echo "$LINE" | awk '{print $9}')

    sleep 1s

    LINE=$(grep "$1" /proc/net/dev | sed s/.*://)
    RECEIVED_NEW=$(echo "$LINE" | awk '{print $1}')
    TRANSMITTED_NEW=$(echo "$LINE" | awk '{print $9}')

    INSPEED=$((("$RECEIVED_NEW" - "$RECEIVED_OLD")))
    OUTSPEED=$((("$TRANSMITTED_NEW" - "$TRANSMITTED_OLD")))
}


subMenuItem() {
    echo "-- $1 | terminal=false bash='echo $1 > $setting' refresh=true"
}

mainMenuItem() {
    # numfmt is available from coreutils ≥ 8.24
    # https://www.gnu.org/software/coreutils/manual/html_node/numfmt-invocation.html
    echo "↑ $(numfmt --to=si "$1") ↓ $(numfmt --to=si "$2")"
    # if [[ $1 -ne 0 && $2 -ne 0 ]]; then
    #     echo "↑ $(numfmt --to=si "$1") ↓ $(numfmt --to=si "$2")"
    #     # else
    #     # echo "Net speed"
    # fi

}

main() {
    if [[ $1 == "all" ]]; then
        while read -r interface; do
            updateUpDown "$interface"
        done < <(grep ":" /proc/net/dev | awk '{print $1}' | sed 's/:.*//')

        mainMenuItem $INSPEED $OUTSPEED
    else
        updateUpDown "$1"

        mainMenuItem $INSPEED $OUTSPEED
    fi

    echo "---"

    echo "Display"

    local interfaces
    interfaces="$(grep ":" /proc/net/dev | awk '{print $1}' | sed 's/:.*//') all"

    for interface in $interfaces; do
        subMenuItem "$interface"
    done
}

main "$DEVICE"

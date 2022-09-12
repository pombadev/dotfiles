#!/usr/bin/env bash

setting="${0%/*}/.argos-netspeed-setting"

DEVICE=$(<"$setting")
DEVICE=${DEVICE:-all}

declare INSPEED
declare OUTSPEED

update() {
    local LINE
    local RECEIVED_OLD
    local TRANSMITTED_OLD
    local RECEIVED_NEW
    local TRANSMITTED_NEW
    local delay=${2:-1}

    LINE=$(grep "$1" /proc/net/dev | sed s/.*://)
    RECEIVED_OLD=$(echo "$LINE" | awk '{print $1}')
    TRANSMITTED_OLD=$(echo "$LINE" | awk '{print $9}')

    sleep "$delay"s

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

getInterfaces() {
    grep ":" /proc/net/dev | awk '{print $1}' | sed 's/:.*//'
}

main() {
    if [[ $1 == "all" ]]; then
        while read -r interface; do
            update "$interface"
        done < <(getInterfaces)

        mainMenuItem $INSPEED $OUTSPEED
    else
        update "$1"

        mainMenuItem $INSPEED $OUTSPEED
    fi

    echo "---"

    echo "Selected interface: $1"

    echo "---"

    echo "Available Interfaces"

    local interfaces
    interfaces="$(getInterfaces) all"

    for interface in $interfaces; do
        subMenuItem "$interface"
    done
}

main "$DEVICE"

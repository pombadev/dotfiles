#!/usr/bin/env bash

setting="${0%/*}/.argos-netspeed-setting"

DEVICE=$(<"$setting")
DEVICE=${DEVICE:-all}

declare -A SPEED

get-up-down() {
    local LINE=$(grep "$1" /proc/net/dev | sed s/.*://)
    SPEED[DOWN]=$(echo "$LINE" | awk '{print $1}')
    SPEED[UP]=$(echo "$LINE" | awk '{print $9}')
}

sub-menu-item() {
    echo "-- $1 | terminal=false bash='echo $1 > $setting' refresh=true"
}

main-menu-item() {
    # numfmt is available from coreutils ≥ 8.24
    # https://www.gnu.org/software/coreutils/manual/html_node/numfmt-invocation.html
    if [[ $1 -ne 0 && $2 -ne 0 ]]; then
        echo "↑ $(numfmt --to=si "$1") ↓ $(numfmt --to=si "$2")"
        # else
        # echo "Net speed"
    fi

}

main() {
    local RECEIVED_OLD
    local RECEIVED_NEW
    local TRANSMITTED_OLD
    local TRANSMITTED_NEW
    local INSPEED
    local OUTSPEED

    if [[ $1 == "all" ]]; then
        while read -r interface; do
            get-up-down "$interface"

            RECEIVED_OLD=${SPEED[DOWN]}
            TRANSMITTED_OLD=${SPEED[UP]}

            sleep 1s

            get-up-down "$interface"

            RECEIVED_NEW=${SPEED[DOWN]}
            TRANSMITTED_NEW=${SPEED[UP]}

            INSPEED=$((("$RECEIVED_NEW" - "$RECEIVED_OLD")))
            OUTSPEED=$((("$TRANSMITTED_NEW" - "$TRANSMITTED_OLD")))
        done < <(grep ":" /proc/net/dev | awk '{print $1}' | sed 's/:.*//')

        main-menu-item $INSPEED $OUTSPEED
    else
        get-up-down "$1"

        RECEIVED_OLD=${SPEED[DOWN]}
        TRANSMITTED_OLD=${SPEED[UP]}

        sleep 1s

        get-up-down "$1"

        RECEIVED_NEW=${SPEED[DOWN]}
        TRANSMITTED_NEW=${SPEED[UP]}

        INSPEED=$((("$RECEIVED_NEW" - "$RECEIVED_OLD")))
        OUTSPEED=$((("$TRANSMITTED_NEW" - "$TRANSMITTED_OLD")))

        main-menu-item $INSPEED $OUTSPEED
    fi
}

main "$DEVICE"

echo "---"

echo "Display"

interfaces="$(grep ":" /proc/net/dev | awk '{print $1}' | sed 's/:.*//') all"

for interface in $interfaces; do
    sub-menu-item "$interface"
done

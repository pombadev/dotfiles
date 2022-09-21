#!/usr/bin/env bash

weather=$(curl -s "wttr.in?format=%c^%t^%C^%l")

condition=$(cut -d'^' -f1 <<<"$weather")
icon=$(cut -d'^' -f2 <<<"$weather")

if [ "$weather" == "" ]; then
    echo "No data"
else
    printf '%s %s\n' "$icon" "$condition"
fi

echo '---'

weather="${weather//^/ }"

echo "${weather:-No data}"

echo '---'

echo "wttr.in | href=https://wttr.in iconName=web-browser"

echo "Reload | iconName=view-refresh-symbolic refresh=true"

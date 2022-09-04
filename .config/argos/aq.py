#!/usr/bin/env python3

import json
from urllib import request

def fetch():
    req = request.Request('https://api.waqi.info/mapq2/nearest')
    req.add_header('Accept', 'application/json')
    req.add_header('User-Agent', 'Argos-Gnome-Extension/User-Script')

    with request.urlopen(req) as response:
        body = response.read()

    return json.loads(body)

def normaliz_stations(data):
    stations = data['data']['stations']
    stations = filter(lambda item: item['aqi'] != '-', stations)
    stations = list(stations)
    stations.sort(key=lambda item: item['distance'])

    return stations

def map_aqi_level(key):
    aqi = int(key)

    if aqi >= 0 and aqi <= 50:
        return ('green', 'Good')
    elif aqi >= 51 and aqi <= 100:
        return ('yellow', 'Moderate')
    elif aqi >= 101 and aqi <= 150:
        return ('orange', 'Unhealthy for Sensitive')
    elif aqi >= 151 and aqi <= 200:
        return ('red', 'Unhealthy')
    elif aqi >= 201 and aqi <= 300:
        return ('magenta', 'Very Unhealthy')
    elif aqi > 300:
        return ('darkRed', 'Hazardous')
    else:
        raise KeyError(f'aqi value should be in range of 0..300, found {key}')

if __name__ == "__main__":
    res = fetch()

    stations = normaliz_stations(res)

    for index, station in enumerate(stations):
        aqi = station['aqi']

        color, status = map_aqi_level(aqi)

        if index == 0:
            print(f"AQI: <span color='{color}'>{aqi}</span>" + '\n' + '---')

        print(f"{aqi}, {status} ({station['name']})")

    print("---")

    print("aqicn.org | href=https://aqicn.org/here/ iconName=web-browser")

    print("---")

    print("Reload | iconName=view-refresh-symbolic refresh=true")

#!/usr/bin/env python3

import json
from urllib import request


def fetch():
    req = request.Request('https://api.waqi.info/mapq2/nearest')
    req.add_header('Accept', 'application/json')
    req.add_header('User-Agent', 'Argos-Gnome-Extension/User-Script')

    with request.urlopen(req, timeout=60 * 60) as response:
        body = response.read()

    return json.loads(body)


def normalize_stations(data):
    stations = data['data']['stations']
    stations = filter(lambda item: item['aqi'] != '-', stations)
    stations = list(stations)
    stations.sort(key=lambda item: item['distance'])

    return stations


LEVELS = [
    ('0-50', 'Good', 'green'),
    ('51-100', 'Moderate', 'yellow'),
    ('101-150', 'Unhealthy for Sensitive', 'orange'),
    ('151-200', 'Unhealthy', 'red'),
    ('201-300', 'Very Unhealthy', 'magenta'),
    ('300+', 'Hazardous', 'darkRed'),
]

# AQI	Air Pollution Level	Health Implications	Cautionary Statement(for PM2.5)
# LEVELS_V2 = [
#     (
#         '0-50',
#         'Good',
#         'Air quality is satisfactory, and air pollution poses little or no risk.',
#         'green'
#     ),
#     (
#         '51-100',
#         'Moderate',
#         'Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution.',
#         'yellow'
#     ),
#     (
#         '101-150',
#         'Unhealthy for Sensitive Groups',
#         'Members of sensitive groups may experience health effects. The general public is less likely to be affected.',
#         'orange'
#     ),
#     (
#         '151-200',
#         'Unhealthy',
#         'Some members of the general public may experience health effects; members of sensitive groups may experience more serious health effects.',
#         'red'
#     ),
#     (
#         '201-300',
#         'Very Unhealthy',
#         'Health alert: The risk of health effects is increased for everyone.',
#         'purple'
#     ),
#     (
#         '300+',
#         'Hazardous',
#         'Health warning of emergency conditions: everyone is more likely to be affected.',
#         'darkRed'
#     )
# ]


def map_aqi_level(key):
    aqi = int(key)

    if aqi >= 0 and aqi <= 50:
        return LEVELS[0]
    elif aqi >= 51 and aqi <= 100:
        return LEVELS[1]
    elif aqi >= 101 and aqi <= 150:
        return LEVELS[2]
    elif aqi >= 151 and aqi <= 200:
        return LEVELS[3]
    elif aqi >= 201 and aqi <= 300:
        return LEVELS[4]
    elif aqi > 300:
        return LEVELS[5]
    else:
        raise KeyError(f'aqi value should be in range of 0..300, found {key}')


if __name__ == "__main__":
    try:
        res = fetch()
    except:
        res = {'data': {'stations': []}}

    if len(res['data']['stations']) == 0:
        print("No data")

    stations = normalize_stations(res)

    for index, station in enumerate(stations):
        aqi = station['aqi']

        _, status, color = map_aqi_level(aqi)

        if index == 0:
            print(f"AQI: <span color='{color}'>{aqi}</span>\n---")

        print(
            f"{station['name']} <span color='{color}'>({aqi}, {status})</span>")

    print("---")

    for (a, b, c) in LEVELS:
        print(f"<tt/> <span color='{c}'>{b} {a}</span>")

    # print("---")
    # for (a, b, c, e) in LEVELS_V2:
    #     # print(f"<tt/> <span color='{e}'>{a} {b} {c}</span>")
    #     print(
    #         f'<big/> <span color="{e}">{a} {b} {c}</span>')

    print("---")

    # with open("/home/pjmp/Downloads/r.resized.png", "rb") as image_file:
    #     import base64
    #     encoded_string = base64.b64encode(
    #         image_file.read()).decode(encoding="utf8")
    #     print(f"| image={encoded_string}")

    print("---")

    print("aqicn.org | href=https://aqicn.org/here/ iconName=web-browser")

    print("---")

    print("Reload | iconName=view-refresh-symbolic refresh=true")

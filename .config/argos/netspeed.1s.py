#!/usr/bin/env python

lines = open("/proc/net/dev", "r").readlines()

columnLine = lines[1]
_, receiveCols , transmitCols = columnLine.split("|")
receiveCols = map(lambda a:"recv_"+a, receiveCols.split())
transmitCols = map(lambda a:"trans_"+a, transmitCols.split())

cols = list(receiveCols)+list(transmitCols)

faces = {}

for line in lines[2:]:
    if line.find(":") < 0: continue
    face, data = line.split(":")
    faceData = dict(zip(cols, data.split()))
    faces[face] = faceData

import pprint

print('=======================================')
pprint.pprint(faces['wlp0s20f3'])

# print(faces['wlp0s20f3']['trans_bytes'], faces['wlp0s20f3']['trans_packets'])

# print(
# 	# int(faces['wlp0s20f3']['trans_bytes']) /1000/1000
# 	int(faces['wlp0s20f3']['trans_packets']) /1000/1000
# )
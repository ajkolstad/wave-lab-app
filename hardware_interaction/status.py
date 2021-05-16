"""
Script to close all valves
"""

from time import sleep
from control import *
from conf import facility_controls

ctrl_DWB = facility_controls['DWB']['basin_north']
ctrl_LWF_north = facility_controls['LWF']['flume_north']
ctrl_LWF_south = facility_controls['LWF']['flume_south']

# prints status of all valves in wave lab on 5 second interval
while True:
    print("DWB")
    print('\t' + ctrl_DWB.status().status)
    print("LWF")
    print('\t' + ctrl_LWF_north.status().status)
    print('\t' + ctrl_LWF_south.status().status)
    sleep(5)

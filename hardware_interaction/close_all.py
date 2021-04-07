"""
Simple script to close all valves
"""

from time import sleep
from control import *
from conf import facility_controls

ctrl_DWB = facility_controls['DWB']['basin_north']
ctrl_LWF_north = facility_controls['LWF']['flume_north']
ctrl_LWF_south = facility_controls['LWF']['flume_south']

ctrl_DWB.close()
ctrl_LWF_north.close()
ctrl_LWF_south.close()

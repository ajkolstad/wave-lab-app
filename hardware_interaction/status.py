"""
Simple script to spew status from an Adam module

Change the IP below as needed.
"""

from time import sleep
from control import *
from conf import facility_controls

ctrl = facility_controls['DWB']['basin_north']
#ctrl = facility_controls['LWF']['flume_north']
#ctrl = facility_controls['LWF']['flume_south']

ctrl.print_status_header()

while 1:
    ctrl.print_status()
    sleep(0.5)


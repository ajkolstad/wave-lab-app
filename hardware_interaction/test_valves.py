"""
IMPORTS
"""
import mysql, time, math, queries
from mysql.connector import Error

from time import sleep
from control import *
from conf import facility_controls

"""
GLOBAL VARIABLES
"""
db = None
query = None
PAUSE = 15

"""
Connects to MySQL database and executes a query for the associated flume / basin depth value
"""
def get_depth(flumeNumber):
    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')

    query = db.cursor()
    if flumeNumber == 0:
        query.execute("SELECT * FROM `depth_data` WHERE Depth_Flume_Name = 0 ORDER BY Ddate DESC LIMIT 1")
        records = query.fetchall()
        for row in records:
            res = row[1]
    elif flumeNumber == 1:
        query.execute('SELECT * FROM `depth_data` WHERE Depth_Flume_Name = 1 ORDER BY Ddate DESC LIMIT 1')
        records = query.fetchall()
        for row in records:
         res = row[1]
    else:
        return
    return res

"""
Tests correct actuation of valves for given facility in order:
1 Set start state closed, no target     detection of no target
2 Set target fill                       opening of valves on target detect
3 Set current depth to target fill      closing of valves on completion
"""
def check_valves(basin):

    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')

    query = db.cursor()

    if basin == 0:
        #setup valve controls and ensure a starting state of closed and no fill target
        print ("Checking DWB")
        ctrl = facility_controls['DWB']['basin_north']

        #if the water valves are open, create start state of closed valves with no target fill
        if ctrl.status().status != "closed":
            ctrl.close()
            sleep(PAUSE)

            #if it doesnt close return error
            if ctrl.status().status != "closed":
                return 1

        #set target fill to current depth + 10
        val = (get_depth(basin) + 10, basin)
        query.execute(sql_update_target_fill, val)
        db.commit()
        sleep(PAUSE)

        if ctrl.status().status != "open":
            return 2

        #set target fill to current depth level
        val = (get_depth(basin), basin)
        query.execute(sql_update_target_fill, val)
        db.commit()
        sleep(PAUSE)

        if ctrl.status().status != "closed":
            return 3
        else:
            return 0

    #LWF
    else:
        #setup valve controls and ensure a starting state of closed and no fill target
        print ("Checking LWF")

        ctrl_north = facility_controls['LWF']['flume_north']
        ctrl_south = facility_controls['LWF']['flume_south']

        #if the water valves are open, create start state of closed valves with no target fill
        if ctrl_north.status().status != "closed":
            ctrl_north.close()
            sleep(PAUSE)
            #if it doesnt close return error
            if ctrl_north.status().status != "closed":
                return 1
        if ctrl_south.status().status != "closed":
            ctrl_south.close()
            sleep(PAUSE)
            if ctrl_south.status().status != "closed":
                return 1

        #set target fill to current depth + 10
        val = (get_depth(basin) + 10, basin)
        query.execute(sql_update_target_fill, val)
        db.commit()
        sleep(PAUSE)
        if ctrl_north.status().status != "open":
            return 2

        #set target fill to current depth level
        val = (get_depth(basin), basin)
        query.execute(sql_update_target_fill, val)
        db.commit()
        sleep(PAUSE)
        if ctrl_north.status().status != "closed":
            return 3
        else:
            return 0

"""
Maps error code to error encountered
"""
def debrief(error_codes):
    if error_codes == 0:
        return "Success"
    if error_codes == 1:
        return "1: Could not create start state of closed valves"
    if error_codes == 2:
        return "2: New target fill didn't open valve(s)"
    if error_codes == 3:
        return "3: Set target fill complete didnt close valve(s)"
    else:
        return "debrief error: unrecognized error code"

if __name__ == '__main__':
    print("Beginning test...")

    DWB_error = check_valves(0)
    print(debrief(DWB_error))

    LWF_error = check_valves(1)
    print(debrief(LWF_error))
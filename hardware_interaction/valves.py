"""
IMPORTS
"""
import mysql, time, math
import queries
from mysql.connector import Error

from time import sleep
from control import *
from conf import facility_controls


"""
GLOBAL VARIABLES
"""
# db = None
# query = None

DB_MONITOR_INTERVAL = 30
DWB_MAX_FILL = 190
LWF_MAX_FILL = 410
STAG_CONSTANT = 25
stagnation = [[],[]]
logFile = open("valve_output.log", "w")
errorFile = open("valve_error.log", "w")


"""
Returns a float truncated to a specific number of decimal places.
"""
def truncate(number, decimals=0):
    if not isinstance(decimals, int):
        raise TypeError("decimal places must be an integer.")
    elif decimals < 0:
        raise ValueError("decimal places has to be 0 or more.")
    elif decimals == 0:
        return math.trunc(number)

    factor = 10.0 ** decimals
    return math.trunc(number * factor) / factor

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
Checks a constantly updated list of previous depth values to ensure that the tank is filling, otherwise sets target as filled to stop filling
"""
def checkStagnate(flumeNumber, newDepth):
    global stagnation
    logFile = open("valve_output.log", "a")
    errorFile = open("valve_error.log", "a")

    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)

    if len(stagnation[flumeNumber]) < 10:
        stagnation[flumeNumber].append(newDepth)
        return False
    else:
        if (stagnation[flumeNumber][9] - stagnation[flumeNumber][0]) < STAG_CONSTANT:
            stagnation[flumeNumber] = []
            if flumeNumber == 0:
                errorFile.write("[Target Monitor][DWB] STAGNATION DETECTED!!! STOPPING FILL\n")
                update_query = """UPDATE target_depth SET isComplete = 1 WHERE Target_Flume_Name = 0;"""
                query.execute(update_query)
                db.commit()
                return True
            else:
                errorFile.write("[Target Monitor][LWF] STAGNATION DETECTED!!! STOPPING FILL\n")
                update_query = """UPDATE target_depth SET isComplete = 1 WHERE Target_Flume_Name = 1;"""
                query.execute(update_query)
                db.commit()
                return True
        else:
            shift = stagnation[flumeNumber].pop(0)
            stagnation[flumeNumber].append(newDepth)
            return False

"""
Loop to call monitoring functions on interval
"""
def monitor_database():
    logFile = open("valve_output.log", "a")

    logFile.write("[Target Monitor][DWB] Starting...\n")
    check_complete_DWB()
    logFile.write("[Target Monitor][LWF] Starting...\n")
    check_complete_LWF()

    i = 0
    while i <= 10:
        sleep(DB_MONITOR_INTERVAL)
        check_complete_DWB()
        check_complete_LWF()

"""
Checks database for DWB target fill, actuates water fill valves depending on if current dpeth is higher than the target depth
"""
def check_complete_DWB():
    current_depth = get_depth(0)
    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)

    logFile = open("valve_output.log", "a")

    query.execute(sql_DWB_check_for_new_target)
    records = query.fetchone()

    if records is None:
        logFile.write("[Target Monitor][DWB] Not filling,   no target found\n")
        return

    else:
        ctrl = facility_controls['DWB']['basin_north']

        if checkStagnate(0, current_depth):
            return
      
        query.execute(sql_DWB_check_if_fill_met)
        records = query.fetchone()

        if current_depth < records[0]:
            logFile.write("[Target Monitor][DWB] Filling\n")
            if ctrl.status().status != "open":
                print("open")
                # ctrl.open()

        elif current_depth >= records[0] or current_depth >= DWB_MAX_FILL:
            logFile.write("[Target Monitor][DWB] Fill finished, updating database\n")
            stagnation[0] = []
            if ctrl.status().status != "closed":
                print("close")
                # ctrl.close()
            high = truncate(records[0], 2) +.05
            low = truncate(records[0], 2) - .05
            val = (low, high)
            query.execute(sql_DWB_update_isComplete, val)
            db.commit()

"""
Checks database for LWF target fill, actuates water fill valves depending on if current dpeth is higher than the target depth
"""
def check_complete_LWF():
    current_depth = get_depth(1)

    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)

    logFile = open("valve_output.log", "a")
  
    query.execute(sql_LWF_check_for_new_target)
    records = query.fetchone()
    if records is None:
        logFile.write("[Target Monitor][LWF] Not filling,   no target found\n")
        return

    else:
        ctrl_north = facility_controls['LWF']['flume_north']
        ctrl_south = facility_controls['LWF']['flume_south']

        if checkStagnate(1, current_depth):
            return

        query.execute(sql_LWF_check_if_fill_met)
        records = query.fetchone()
        if current_depth < records[0]:
            logFile.write("[Target Monitor][LWF] Filling\n")
            if ctrl_north.status().status != "open":
                print("open north")
                # ctrl_north.open()
            if ctrl_south.status().status != "open":
                print("open south")
                # ctrl_south.open()

        elif current_depth >= records[0] or current_depth >= LWF_MAX_FILL:
            logFile.write("[Target Monitor][LWF] Fill finished, updating database\n")
            stagnation[1] = []
            if ctrl_north.status() != "closed":
                print("[close north")
                # ctrl_north.close()
            if ctrl_south.status() != "closed":
                print("close south")
                # ctrl_south.close()
            high = truncate(records[0], 2) +.05
            low = truncate(records[0], 2) - .05
            val = (low, high)
            query.execute(sql_LWF_update_isComplete, val)
            db.commit()

"""
Sets up globals then moves to monitor
"""
if __name__ == '__main__':

    monitor_database()


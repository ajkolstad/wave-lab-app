"""
IMPORTS
"""
import mysql, time, math, sys
from mysql.connector import Error

from time import sleep
from control import *
from conf import facility_controls


"""
GLOBALS
"""
sql_DWB_check_for_new_target = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 0 and isComplete = 0 ORDER BY Tdate DESC LIMIT 1;"
sql_LWF_check_for_new_target = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 1 and isComplete = 0 ORDER BY Tdate DESC LIMIT 1;"
sql_DWB_check_if_fill_met = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 0 ORDER BY Tdate DESC LIMIT 1;"
sql_LWF_check_if_fill_met = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 1 ORDER BY Tdate DESC LIMIT 1;"
sql_DWB_update_isComplete = """UPDATE target_depth SET isComplete = 1 WHERE Tdepth > %s AND Tdepth < %s AND Target_Flume_Name = 0;"""
sql_LWF_update_isComplete = """UPDATE target_depth SET isComplete = 1 WHERE Tdepth > %s AND Tdepth < %s AND Target_Flume_Name = 1;"""

stagnation = [[],[]]

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
Checks a constantly updated list of previous depth values to ensure that the tank is filling,
otherwise sets target as filled to stop filling
"""
def checkStagnate(flumeNumber, newDepth, stagConstant, errorPath):
    global stagnation
    errorFile = open(errorPath, "a")

    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)

    if len(stagnation[flumeNumber]) < 10:
        stagnation[flumeNumber].append(newDepth)
        return False
    else:
        if (stagnation[flumeNumber][9] - stagnation[flumeNumber][0]) < stagConstant:
            stagnation[flumeNumber] = []
            if flumeNumber == 0:
                errorFile.write("%s - [DWB] STAGNATION DETECTED!!! STOPPING FILL\n" % time.asctime( time.localtime(time.time()) ))
                update_query = """UPDATE target_depth SET isComplete = 1 WHERE Target_Flume_Name = 0;"""
                query.execute(update_query)
                db.commit()
                return True
            else:
                errorFile.write("%s - [LWF] STAGNATION DETECTED!!! STOPPING FILL\n" % time.asctime( time.localtime(time.time()) ))
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
def monitor_database(interval, dwbMax, lwf_max, stag, logPath, errorPath):
    logFile = open(logPath, "a")
    logFile.write("%s - [DWB] Starting...\n" % time.asctime( time.localtime(time.time()) ))
    logFile.write("%s - [LWF] Starting...\n" % time.asctime( time.localtime(time.time()) ))
    logFile.close()

    check_complete_DWB(dwbMax, stag, logPath, errorPath)
    check_complete_LWF(lwfMax, stag, logPath, errorPath)

    i = 0
    while i <= 10:
        sleep(interval)
        check_complete_DWB(dwbMax, stag, logPath, errorPath)
        check_complete_LWF(lwfMax, stag, logPath, errorPath)

"""
Checks database for DWB target fill, actuates water fill valves depending on if current depth
is higher than the target depth
"""
def check_complete_DWB(dwbMax, stag, logPath, errorPath):
    current_depth = get_depth(0)
    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)

    logFile = open(logPath, "a")

    query.execute(sql_DWB_check_for_new_target)
    records = query.fetchone()

    if records is None:
        logFile.write("%s - [DWB] Not filling,   no target found\n" % time.asctime( time.localtime(time.time()) ))
        return

    else:
        ctrl = facility_controls['DWB']['basin_north']

        if checkStagnate(0, current_depth, stag, errorPath):
            return

        query.execute(sql_DWB_check_if_fill_met)
        records = query.fetchone()

        if records[0] >= float(dwbMax * .95):
            logFile.write("%s - [DWB] Target is over maximum fill level. Marking complete.\n" % time.asctime( time.localtime(time.time()) ))
            high = truncate(records[0], 2) +.05
            low = truncate(records[0], 2) - .05
            val = (low, high)
            query.execute(sql_DWB_update_isComplete, val)
            db.commit()

        elif current_depth < records[0]:
            logFile.write("%s - [DWB] Filling\n" % time.asctime( time.localtime(time.time()) ))
            if ctrl.status().status != "open":
                print("dwb open")
                # ctrl.open()

        elif current_depth >= records[0] or current_depth >= float(dwbMax * .95):
            logFile.write("%s - [DWB] Fill finished, updating database\n" % time.asctime( time.localtime(time.time()) ))
            stagnation[0] = []
            if ctrl.status().status != "closed":
                print("dwb close")
                # ctrl.close()
            high = truncate(records[0], 2) +.05
            low = truncate(records[0], 2) - .05
            val = (low, high)
            query.execute(sql_DWB_update_isComplete, val)
            db.commit()

"""
Checks database for LWF target fill, actuates water fill valves depending on if current depth
is higher than the target depth
"""
def check_complete_LWF(lwfMax, stag, logPath, errorPath):
    current_depth = get_depth(1)

    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)

    logFile = open(logPath, "a")

    query.execute(sql_LWF_check_for_new_target)
    records = query.fetchone()
    if records is None:
        logFile.write("%s - [LWF] Not filling,   no target found\n" % time.asctime( time.localtime(time.time()) ))
        return

    else:
        ctrl_north = facility_controls['LWF']['flume_north']
        ctrl_south = facility_controls['LWF']['flume_south']

        if checkStagnate(1, current_depth, stag, errorPath):
            return

        query.execute(sql_LWF_check_if_fill_met)
        records = query.fetchone()

        if records[0] >= float(lwfMax * .95):
            logFile.write("%s - [LWF] Target is over maximum fill level. Marking complete.\n" % time.asctime( time.localtime(time.time()) ))
            high = truncate(records[0], 2) +.05
            low = truncate(records[0], 2) - .05
            val = (low, high)
            query.execute(sql_LWF_update_isComplete, val)
            db.commit()

        elif current_depth < records[0]:
            logFile.write("%s - [LWF] Filling\n" % time.asctime( time.localtime(time.time()) ))
            if ctrl_north.status().status != "open":
                print("open north")
#                ctrl_north.open()
            if ctrl_south.status().status != "open":
                print("open south")
#                ctrl_south.open()

        elif current_depth >= records[0] or current_depth >= float(lwfMax * .95):
            logFile.write("%s - [LWF] Fill finished, updating database\n" % time.asctime( time.localtime(time.time()) ))
            stagnation[1] = []
            if ctrl_north.status() != "closed":
                print("close north")
#                ctrl_north.close()
            if ctrl_south.status() != "closed":
                print("close south")
#                ctrl_south.close()
            high = truncate(records[0], 2) +.05
            low = truncate(records[0], 2) - .05
            val = (low, high)
            query.execute(sql_LWF_update_isComplete, val)
            db.commit()

"""
Grabs cmd line arguements, sets, outputs status, then moves to monitor
"""
if __name__ == '__main__':
    if len(sys.argv) <= 6 or len(sys.argv) > 7:
        sys.exit("Missing cmd line arguments:\n\tpython valves.py [Update Interval] [DWB Max] [LWF Max] [Stagnation] [Log] [Error]")

    interval = int(sys.argv[1])
    dwbMax = float(sys.argv[2])
    lwfMax = float(sys.argv[3])
    stag = float(sys.argv[4])
    logPath = sys.argv[5]
    errorPath = sys.argv[6]

    logFile = open(logPath, "w")
    errorFile = open(errorPath, "w")
    logFile.write("Repeat interval:\t\t" + str(interval) + "s\n")
    logFile.write("DWB Max:\t\t\t" + str(dwbMax) + "m\n")
    logFile.write("LWF Max:\t\t\t" + str(lwfMax) + "m\n")
    logFile.write("Min fill / 10 intervals:\t" + str(stag) + "m\n\n")
    errorFile.write("Successfully started")
    logFile.close()
    errorFile.close()

    monitor_database(interval, dwbMax, lwfMax, stag, logPath, errorPath)

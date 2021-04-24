"""
IMPORTS
"""
import mysql, time, math
from mysql.connector import Error

from time import sleep
from control import *
from conf import facility_controls


"""
GLOBAL VARIABLES
"""
db = None
query = None
DB_MONITOR_INTERVAL = 30
DWB_MAX_FILL = 190
LWF_MAX_FILL = 410
STAG_CONSTANT = 25
stagnation = [[],[]]
logFile = open("output.log", "w")
errorFile = open("error.log", "w")

sql_check_for_new_target = """SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = %s and isComplete = 0 ORDER BY Tdate DESC LIMIT 1;"""
sql_check_if_fill_met = """SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = %s ORDER BY Tdate DESC LIMIT 1;"""
sql_update_isComplete = """UPDATE target_depth SET isComplete = 1 WHERE Target_Flume_Name = %s;"""

sql_DWB_check_for_new_target = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 0 and isComplete = 0 ORDER BY Tdate DESC LIMIT 1;"
sql_LWF_check_for_new_target = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 1 and isComplete = 0 ORDER BY Tdate DESC LIMIT 1;"
sql_DWB_check_if_fill_met = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 0 ORDER BY Tdate DESC LIMIT 1;"
sql_LWF_check_if_fill_met = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 1 ORDER BY Tdate DESC LIMIT 1;"
sql_DWB_update_isComplete = """UPDATE target_depth SET isComplete = 1 WHERE Tdepth > %s AND Tdepth < %s AND Target_Flume_Name = 0;"""
sql_LWF_update_isComplete = """UPDATE target_depth SET isComplete = 1 WHERE Tdepth > %s AND Tdepth < %s AND Target_Flume_Name = 1;"""

"""
FUNCITONS
"""
"""
Returns a value truncated to a specific number of decimal places.
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
Connects to database and executes a query for the associated flume / basin, otherwise returns none
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
Checks a global list of previous depth values to ensure that the tank is filling, if its not, sets target as filled
"""
def checkStagnate(flumeNumber, newDepth):
    global stagnation
    logFile = open("output.log", "a")
    errorFile = open("error.log", "a")

    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)

    # if stagnation queue not filled, append latest depth
    if len(stagnation[flumeNumber]) < 10:
        stagnation[flumeNumber].append(newDepth)
        return False
    else:
        # if fill isn't past minimum fill interval (newest depth - oldest depth), update target to filled
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
        # if fill is making progress, remove oldest depth, append newest depth
        else:
            shift = stagnation[flumeNumber].pop(0)
            stagnation[flumeNumber].append(newDepth)
            return False

"""
Constant daemon to monitor LWF and DWB on interval
"""
def monitor_database():
    logFile = open("output.log", "a")

    logFile.write("[Target Monitor][DWB] Starting...\n")
    check_complete_DWB()
    logFile.write("[Target Monitor][LWF] Starting...\n")
    check_complete_LWF()

    i = 0
    while i <= 10:
        sleep(DB_MONITOR_INTERVAL)
        check_complete_DWB()
        check_complete_LWF()

def check_complete_DWB():
    current_depth = get_depth(0)
    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)

    logFile = open("output.log", "a")

    # Executes query to get the currently set targets if they exist, then fetchs the closest upcoming / currently enacted
    query.execute(sql_DWB_check_for_new_target)
    records = query.fetchone()

    #if no fill target is present, output statement and return
    if records is None:
        logFile.write("[Target Monitor][DWB] Not filling,   no target found\n")
        return

    #otherwise a fill target exists and could need to be acted upon
    else:
        # get facility controls and print status to terminal
        ctrl = facility_controls['DWB']['basin_north']

        # if stagnating, exit
        if checkStagnate(0, current_depth):
            return

        query.execute(sql_DWB_check_if_fill_met)
        records = query.fetchone()

        #if no fill target is present, output statement and return
        if current_depth < records[0]:
            logFile.write("[Target Monitor][DWB] Filling\n")
            if ctrl.status().status != "open":
                print()
                # ctrl.open()

        elif current_depth >= records[0] or current_depth >= DWB_MAX_FILL:
            logFile.write("[Target Monitor][DWB] Fill finished, updating database\n")
            stagnation[0] = []
            if ctrl.status().status != "closed":
                print()
                # ctrl.close()
            high = truncate(records[0], 2) +.05
            low = truncate(records[0], 2) - .05
            val = (low, high)
            query.execute(sql_DWB_update_isComplete, val)
            db.commit()

def check_complete_LWF():
    current_depth = get_depth(1)
    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)

    logFile = open("output.log", "a")

    # Executes query to get the currently set targets if they exist, then fetchs the closest upcoming / currently enacted
    query.execute(sql_LWF_check_for_new_target)
    records = query.fetchone()
    if records is None:
        logFile.write("[Target Monitor][LWF] Not filling,   no target found\n")
        return

    #otherwise a fill target exists and could need to be acted upon
    else:
        # get facility controls and print status to terminal
        ctrl_north = facility_controls['LWF']['flume_north']
        ctrl_south = facility_controls['LWF']['flume_south']

        # if stagnating, exit
        if checkStagnate(1, current_depth):
            return

        query.execute(sql_LWF_check_if_fill_met)
        records = query.fetchone()
        if current_depth < records[0]:
            logFile.write("[Target Monitor][LWF] Filling\n")
            if ctrl_north.status().status != "open":
                print()
                # ctrl_north.open()
            if ctrl_south.status().status != "open":
                print()
                # ctrl_south.open()

        elif current_depth >= records[0] or current_depth >= LWF_MAX_FILL:
            logFile.write("[Target Monitor][LWF] Fill finished, updating database\n")
            stagnation[1] = []
            if ctrl_north.status() != "closed":
                print("[Target Monitor][LWF] Closing north valve")
                # ctrl_north.close()
            if ctrl_south.status() != "closed":
                print("[Target Monitor][LWF] Closing south valve")
                # ctrl_south.close()
            high = truncate(records[0], 2) +.05
            low = truncate(records[0], 2) - .05
            val = (low, high)
            query.execute(sql_LWF_update_isComplete, val)
            db.commit()

def checkComplete(flumeNumber):
    ctrl = []

    current_depth = get_depth(flumeNumber)
    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)

    # Executes query to get the currently set targets if they exist, then fetchs the closest upcoming / currently enacted
    val = (flumeNumber)
    query.execute(sql_check_for_new_target, val)
    records = query.fetchone()

    #if no fill target is present, output statement and return
    if records is None:
        print("[Target Monitor][DWB] Not filling    no target found")
        return

    #otherwise a fill target exists and could need to be acted upon
    else:
        # get facility controls and print status to terminal
        if flumeNumber == 0:
            ctrls.append(facility_controls['DWB']['basin_north'])
        else:
            ctrls.append(facility_controls['LWF']['flume_north'])
            ctrls.append(facility_controls['LWF']['flume_south'])

        date = records[2]
        val = (flumeNumber)
        query.execute(sql_check_if_fill_met, val)
        records = query.fetchone()

        #if no fill target is present, output statement and return
        if current_depth < records[0]:
            if flumeNumber == 0:
                print("[Target Monitor][DWB] Filling    ", current_depth, " ==> ", truncate(records[0], 2))
            else:
                print("[Target Monitor][LWF] Filling    ", current_depth, " ==> ", truncate(records[0], 2))

            for ctrl in ctrls:
                if ctrl.status().status != "open":
                    ctrl.open()

        elif current_depth >= records[0] or current_depth >= DWB_MAX_FILL:
            if flumeNumber == 0:
                print("[Target Monitor][DWB] Fill finished, updating database")
            else:
                print("[Target Monitor][LWF] Fill finished, updating database")
            for ctrl in ctrls:
                if ctrl.status().status != "closed":
                    ctrl.close()

            high = truncate(records[0], 2) +.05
            low = truncate(records[0], 2) - .05
            val = (flumeNumber)
            query.execute(sql_update_isComplete, val)
            db.commit()


"""
APPLICATION
"""

if __name__ == '__main__':
    monitor_database()

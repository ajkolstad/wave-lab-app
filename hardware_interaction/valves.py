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
DB_MONITOR_INTERVAL = 15

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
    # db = mysql.connector.connect(
    #         host = os.getenv('DATABASE_HOST'),
    #         user = os.getenv('DATABASE_USER'),
    #         password = os.getenv('DATABASE_PASSWORD'),
    #         database = os.getenv('DATABASE')
    # )
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
Constant daemon to monitor LWF and DWB on interval
"""
def monitor_database():

    print("[Target Monitor][DWB] Starting...")
    check_complete_DWB()
    print("[Target Monitor][LWF] Starting...")
    check_complete_LWF()

    i = 0
    while i <= 10:
        sleep(DB_MONITOR_INTERVAL)
        check_complete_DWB()
        check_complete_LWF()

def check_complete_DWB():
    current_depth = get_depth(0)
    # db = mysql.connector.connect(
    #         host = os.getenv('DATABASE_HOST'),
    #         user = os.getenv('DATABASE_USER'),
    #         password = os.getenv('DATABASE_PASSWORD'),
    #         database = os.getenv('DATABASE')
    # )
    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)

    # Executes query to get the currently set targets if they exist, then fetchs the closest upcoming / currently enacted
    query.execute(sql_DWB_check_for_new_target)
    records = query.fetchone()

    #if no fill target is present, output statement and return
    if records is None:
        print("[Target Monitor][DWB] Not filling    no target found")
        return

    #otherwise a fill target exists and could need to be acted upon
    else:
        # get facility controls and print status to terminal
        ctrl = facility_controls['DWB']['basin_north']

        date = records[2]
        query.execute(sql_DWB_check_if_fill_met)
        records = query.fetchone()

        #if no fill target is present, output statement and return
        if current_depth < records[0]:
            print "[Target Monitor][DWB] Filling    ", current_depth, " ==> ", truncate(records[0], 2)
            if ctrl.status().status != "open":
                print "[Target Monitor][DWB] Opening valve"
                ctrl.open()

        elif current_depth >= records[0]:
            print("[Target Monitor][DWB] Fill finished, updating database")
            if ctrl.status().status != "closed":
                print "[Target Monitor][DWB] Closing valve"
                ctrl.close()
            high = truncate(records[0], 2) +.05
            low = truncate(records[0], 2) - .05
            val = (low, high)
            query.execute(sql_DWB_update_isComplete, val)
            db.commit()


def check_complete_LWF():
    current_depth = get_depth(1)
    # db = mysql.connector.connect(
    #         host = os.getenv('DATABASE_HOST'),
    #         user = os.getenv('DATABASE_USER'),
    #         password = os.getenv('DATABASE_PASSWORD'),
    #         database = os.getenv('DATABASE')
    # )
    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)

    # Executes query to get the currently set targets if they exist, then fetchs the closest upcoming / currently enacted
    query.execute(sql_LWF_check_for_new_target)
    records = query.fetchone()
    if records is None:
        print("[Target Monitor][LWF] Not filling,   no target found")
        return

    #otherwise a fill target exists and could need to be acted upon
    else:
        # get facility controls and print status to terminal
        ctrl_north = facility_controls['LWF']['flume_north']
        ctrl_south = facility_controls['LWF']['flume_south']

        date = records[2]
        query.execute(sql_LWF_check_if_fill_met)
        records = query.fetchone()
        if current_depth < records[0]:
            print "[Target Monitor][LWF] Filling    ", current_depth, " ==> ", truncate(records[0], 2)
            if ctrl_north.status().status != "open":
                print "[Target Monitor][LWF] Opening north valve"
                ctrl_north.open()
            if ctrl_south.status().status != "open":
                print "[Target Monitor][LWF] Opening south valve"
                ctrl_south.open()

        elif current_depth > records[0]:
            print("[Target Monitor][LWF] Fill finished, updating database")
            if ctrl_north.status() != "closed":
                print "[Target Monitor][LWF] Closing north valve"
                ctrl_north.close()
            if ctrl_south.status() != "closed":
                print "[Target Monitor][LWF] Closing south valve"
                ctrl_south.close()
            high = truncate(records[0], 2) +.05
            low = truncate(records[0], 2) - .05
            val = (low, high)
            query.execute(sql_LWF_update_isComplete, val)
            db.commit()


"""
APPLICATION
"""

if __name__ == '__main__':
#     connect_db()
    monitor_database()
#     close_db()

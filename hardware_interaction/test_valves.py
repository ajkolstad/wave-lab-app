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

sql_check_for_new_target = """SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = %s and isComplete = 0 ORDER BY Tdate DESC LIMIT 1;"""
sql_update_target_fill = """UPDATE `target_depth` SET `Tdepth`= %s, `isComplete`= 0, Tdate = CURRENT_TIMESTAMP WHERE Target_Flume_Name = %s"""

"""
FUNCITONS
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


def check_valves(basin):
    #DWB
    if basin:
        #setup valve controls and ensure a starting state of closed and no fill target
        print ("Checking LWF")
        ctrl = facility_controls['DWB']['basin_north']

        #if the water valves are open, create start state of closed valves with no target fill
        if ctrl.status().status != "closed":
            ctrl.close()
            sleep(10)

            #if it doesnt close return error
            if ctrl.status().status != "closed":
                return 1

        #set target fill to current depth + 10
        val = (get_depth(basin) + 10, basin)
        query.execute(sql_update_target_fill, val)
        sleep(15)
        if ctrl.status().status != "open":
            return 2

        #set target fill to current depth level
        val = (get_depth(basin), basin)
        query.execute(sql_update_target_fill, val)
        sleep(15)
        if ctrl.status().status != "closed":
            return 3
        else:
            return 0

    #LWF
    else:
        #setup valve controls and ensure a starting state of closed and no fill target
        print ("Checking DWB")
        ctrl_north = facility_controls['LWF']['flume_north']
        ctrl_south = facility_controls['LWF']['flume_south']

        #if the water valves are open, create start state of closed valves with no target fill
        if ctrl_north.status().status != "closed":
            ctrl_north.close()
            sleep(10)
            #if it doesnt close return error
            if ctrl_north.status().status != "closed":
                return 1
        if ctrl_south.status().status != "closed":
            ctrl_north.close()
            sleep(10)
            if ctrl_south.status().status != "closed":
                return 1

        #set target fill to current depth + 10
        val = (get_depth(basin) + 10, basin)
        query.execute(sql_update_target_fill, val)
        sleep(15)
        if ctrl.status().status != "open":
            return 2

        #set target fill to current depth level
        val = (get_depth(basin), basin)
        query.execute(sql_update_target_fill, val)
        sleep(15)
        if ctrl.status().status != "closed":
            return 3
        else:
            return 0


def debrief(error_codes):
    if error_codes == 0:
        return "Success"
    if error_codes == 1:
        return "Could not create start state of closed valves"
    if error_codes == 2:
        return "New target fill didn't open valve(s)"
    if error_codes == 3:
        return "Set target fill to current depth didnt close valve(s)"
    else:
        return "debrief error: unrecognized error code"

if __name__ == '__main__':
    print("Beginning test...")
"""
    DWB_error = check_valves(0)
    print(debief(DWB_error))

    LWF_error = check_valves(1)
    print(debrief(LWF_error))
"""

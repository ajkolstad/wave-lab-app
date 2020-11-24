"""
IMPORTS and VARIABLES
"""
import mysql, time, math
from mysql.connector import Error


db = None
query = None
DB_MONITOR_INTERVAL = 2

sql_DWB_check_for_new_target = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 0 and isComplete = 0 ORDER BY Tdate DESC LIMIT 1;"
sql_LWF_check_for_new_target = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 1 and isComplete = 0 ORDER BY Tdate DESC LIMIT 1;"
sql_DWB_check_if_fill_met = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 0 ORDER BY Tdate DESC LIMIT 1;"
sql_LWF_check_if_fill_met = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 1 ORDER BY Tdate DESC LIMIT 1;"
sql_DWB_update_isComplete = "UPDATE target_depth SET isComplete = 1 WHERE Tdepth > %s AND Tdepth < %s AND Target_Flume_Name = 0;"
sql_LWF_update_isComplete = "UPDATE target_depth SET isComplete = 1 WHERE Tdepth > %s AND Tdepth < %s AND Target_Flume_Name = 1;"

"""
FUNCITONS
"""
def connect_db():
    """ Connect to MySQL database """
    try:
        db = mysql.connector.connect(host='localhost',
                                       database='wave_lab_database',
                                       user='root',
                                       password='')
        if db.is_connected():
            print('[Valves] Connected to Database')

    except Error as err:
        print(err)

def close_db():
    if db is not None and db.is_connected():
        print("[Target Monitor] Closing Database")
        db.close()
    else:
        printf("[Target Monitor] Database not closed successfully")

def truncate(number, decimals=0):
    """
    Returns a value truncated to a specific number of decimal places.
    """
    if not isinstance(decimals, int):
        raise TypeError("decimal places must be an integer.")
    elif decimals < 0:
        raise ValueError("decimal places has to be 0 or more.")
    elif decimals == 0:
        return math.trunc(number)

    factor = 10.0 ** decimals
    return math.trunc(number * factor) / factor

def get_depth(flumeNumber):
    
    db = mysql.connector.connect(host='localhost',
                                       database='wave_lab_database',
                                       user='root',
                                       password='')
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
    

def monitor_database():
    print("[Target Monitor][DWB] Starting...")
    check_complete_DWB()
    print("[Target Monitor][LWF] Starting...")
    check_complete_LWF()

    i = 0
    while i <= 10:
        time.sleep(DB_MONITOR_INTERVAL)
        check_complete_DWB()
        check_complete_LWF()

def check_complete_DWB():
    current_depth = get_depth(0)
    db = mysql.connector.connect(host='localhost',
                                       database='wave_lab_database',
                                       user='root',
                                       password='')
    query = db.cursor(prepared = True)
    
    query.execute(sql_DWB_check_for_new_target)
    records = query.fetchone()

    if records is None:
        print("[Target Monitor][DWB] Not filling    no target found")
    else:
        date = records[2]
        query.execute(sql_DWB_check_if_fill_met)
        records = query.fetchone()
        if current_depth < records[0]:
            print("[Target Monitor][DWB] Filling    ", current_depth, " ==> ", truncate(records[0], 2))

        elif current_depth >= records[0]:
            high = truncate(records[0], 2) +.05
            low = truncate(records[0], 2) - .05
            print("[Target Monitor][DWB] Fill finished, updating database")
            query.execute("UPDATE target_depth SET isComplete = 1 WHERE Tdepth > %s AND Tdepth < %s AND Target_Flume_Name = 0", (low, high))

        
def check_complete_LWF():
    current_depth = get_depth(1)
    db = mysql.connector.connect(host='localhost',
                                       database='wave_lab_database',
                                       user='root',
                                       password='')
    query = db.cursor(prepared = True)
    
    query.execute(sql_LWF_check_for_new_target)
    records = query.fetchone()
    if records is None:
        print("[Target Monitor][LWF] Not filling,   no target found")
    else:
        date = records[2]
        query.execute(sql_LWF_check_if_fill_met)
        records = query.fetchone()
        if current_depth < records[0]:
            print("[Target Monitor][LWF] Filling    ", current_depth, " ==> ", truncate(records[0], 2))

        elif current_depth > records[0]:
            high = truncate(records[0], 2) +.05
            low = truncate(records[0], 2) - .05
            print("[Target Monitor][LWF] Fill finished, updating database")
            query.execute("UPDATE target_depth SET isComplete = 1 WHERE Tdepth > %s AND Tdepth < %s AND Target_Flume_Name = 1", (low, high))


"""
APPLICATION
"""

if __name__ == '__main__':
    connect_db()
    monitor_database()
    close_db()
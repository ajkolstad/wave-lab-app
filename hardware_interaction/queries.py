"""
SQL Queries
"""
# valves
sql_check_for_new_target = """SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = %s and isComplete = 0 ORDER BY Tdate DESC LIMIT 1;"""
sql_check_if_fill_met = """SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = %s ORDER BY Tdate DESC LIMIT 1;"""
sql_update_isComplete = """UPDATE target_depth SET isComplete = 1 WHERE Target_Flume_Name = %s;"""

sql_DWB_check_for_new_target = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 0 and isComplete = 0 ORDER BY Tdate DESC LIMIT 1;"
sql_LWF_check_for_new_target = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 1 and isComplete = 0 ORDER BY Tdate DESC LIMIT 1;"
sql_DWB_check_if_fill_met = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 0 ORDER BY Tdate DESC LIMIT 1;"
sql_LWF_check_if_fill_met = "SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 1 ORDER BY Tdate DESC LIMIT 1;"
sql_DWB_update_isComplete = """UPDATE target_depth SET isComplete = 1 WHERE Tdepth > %s AND Tdepth < %s AND Target_Flume_Name = 0;"""
sql_LWF_update_isComplete = """UPDATE target_depth SET isComplete = 1 WHERE Tdepth > %s AND Tdepth < %s AND Target_Flume_Name = 1;"""

# test
sql_check_for_new_target = """SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = %s and isComplete = 0 ORDER BY Tdate DESC LIMIT 1;"""
sql_update_target_fill = """UPDATE `target_depth` SET `Tdepth`= %s, `isComplete`= 0, Tdate = CURRENT_TIMESTAMP WHERE Target_Flume_Name = %s"""

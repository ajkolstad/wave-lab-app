"""
Transfers SQLite depth database information over to MySQL database 
"""
import sys, os, os.path
import mysql, time, math
from mysql.connector import Error
import sqlalchemy as sqlite_db

from datetime import datetime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import (
    Column,
    Float,
    Integer,
    DateTime
    )

"""
GLOBALS
"""
Base = declarative_base()
class Data(Base):
    __tablename__ = 'data'
    id = Column(Integer, primary_key=True)
    value = Column(Float, index=True)
    basin = Column(Integer, index=True) # flume=0, basin=1
    datetime = Column(DateTime, index=True)

FACILITIES = [ "LWF", "DWB"]

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
Queries the SQLite databse for the most recent depth for both flume and basin, returns appropriate one
"""
def getDepth(basin, filepath):
    engine = sqlite_db.create_engine('sqlite:///%s' % filepath)
    connection = engine.connect()
    metaData = sqlite_db.MetaData()

    depths = sqlite_db.Table('data', metaData, autoload=True, autoload_with=engine)
    Session = sessionmaker(bind = engine)
    session = Session()

    results = session.query(Data).order_by(Data.datetime.desc()).limit(2)
    if basin == 1:
        return results[1]
    elif basin == 0:
        return results[0]
    else:
        return

"""
Cleans out old entries from the MySQL depth table
"""
def cleanDepthTable():
    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)
    cleanDB = """DELETE FROM `depth_data` WHERE Ddate < (SELECT DATE_ADD(NOW(), INTERVAL -7 DAY))"""
    query.execute(cleanDB)
    db.commit()

"""
Updates MySQL database with depth information
"""
def update(basin):
    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)


    UPDATE_DB = """INSERT INTO `depth_data`(`Ddate`, `Depth`, `Depth_Flume_Name`) VALUES (CURRENT_TIMESTAMP, %s, %s)"""

    val = ()
    if basin.basin == 0:
        val = (truncate(basin.value / 100, 2), 1)
    elif basin.basin == 1:
        val = (truncate(basin.value / 100, 2), 0)
    query.execute(UPDATE_DB, val)
    db.commit()

"""
Verifies existence of SQLite file, then loops to update on interval
"""
def updateDB(filePath, monitor_interval, logPath):

    while(True):
        logFile = open(logPath, "a")
        DWB = getDepth(0, filePath)
        LWF = getDepth(1, filePath)

        update(DWB)
        logFile.write("%s - DWB updated\n" % time.asctime( time.localtime(time.time()) ))
        time.sleep(2)

        update(LWF)
        logFile.write("%s - LWF updated\n" % time.asctime( time.localtime(time.time()) ))
        time.sleep(2)

        cleanDepthTable()
        time.sleep(monitor_interval)
        logFile.close()


if __name__ == "__main__":
    if len(sys.argv) <= 3 or len(sys.argv) > 4:
        sys.exit("Missing cmd line arguments:\n\tpython depth_sensor.py [Path] [Log] [Interval]")

    filepath = sys.argv[1]
    logPath = sys.argv[2]
    monitor_interval = int(sys.argv[3])

    logFile = open(logPath, "w")
    if os.path.exists(filepath):
        logFile.write("File exists: %s\n\n" % filepath)
    else:
        sys.exit("File doesn't exist: %s" % filepath)
    logFile.close()

    updateDB(filepath, monitor_interval, logPath)

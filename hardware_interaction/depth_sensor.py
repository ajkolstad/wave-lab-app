# python2 depth_sensor.py {sqlite filepath} {db monitor interval}

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

Base = declarative_base()
class Data(Base):
    __tablename__ = 'data'
    id = Column(Integer, primary_key=True)
    value = Column(Float, index=True)
    basin = Column(Integer, index=True) # flume=0, basin=1
    datetime = Column(DateTime, index=True)

# db = None
# query = None

PAUSE = 2.5
ARCHIVE = "/a1/walve/data"
FACILITIES = [ "LWF", "DWB"]
logFile = open("depth_output.log", "w")

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
        val = (basin.value, 1)
    elif basin.basin == 1:
        val = (basin.value, 0)
    query.execute(UPDATE_DB, val)
    db.commit()

"""
Verifies existence of SQLite file, then loops to update on interval
"""
def updateDB(filepath, monitor_interval):
    logFile = open("depth_output.log", "a")

    if os.path.exists(filepath):
        logFile.write("File exists: %s\n" % filepath)
    else:
        # print("File doesn't exist: %s" % DBFILEPATH)
        sys.exit("File doesn't exist: %s" % filepath)

    while(True):
        logFile.write("Getting new depths\n")
        DWB = getDepth(0, filepath)
        LWF = getDepth(1, filepath)

        update(DWB)
        logFile.write("%s - DWB updated\n" % time.asctime( time.localtime(time.time()) ))
        time.sleep(PAUSE)

        update(LWF)
        logFile.write("%s - LWF updated\n" % time.asctime( time.localtime(time.time()) ))
        time.sleep(PAUSE)
        
        cleanDepthTable()
        time.sleep(monitor_interval)


if __name__ == "__main__":

    filepath = sys.argv[1]
    monitor_interval = int(sys.argv[2]) | 30
    updateDB(filepath, monitor_interval)

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

db = None
query = None
DB_MONITOR_INTERVAL = 30
DEBUG = False

ARCHIVE = "/a1/walve/data"
FACILITIES = [ "LWF", "DWB"]

# The file path of the sqlite database
DBFILEPATH = "/a1/walve/data/levels.sqlite"
# DBFILEPATH = "levels.sqlite"

def getDepth(basin):
    # Create db connection and metadata
    engine = sqlite_db.create_engine('sqlite:///%s' % DBFILEPATH, echo=DEBUG)
    connection = engine.connect()
    metaData = sqlite_db.MetaData()

    # Load data table
    depths = sqlite_db.Table('data', metaData, autoload=True, autoload_with=engine)
    Session = sessionmaker(bind = engine)
    session = Session()

    results = session.query(Data).order_by(Data.datetime.desc()).limit(2)
    if basin == 1:
        return results[1]
    elif basin == 0:
        return results[0]
    else:
        print("\terror, not valid basin")

def updateDB(basin):
    db = mysql.connector.connect(host='engr-db.engr.oregonstate.edu',
                                       database='wave_lab_database',
                                       user='wave_lab_database',
                                       password='1amSmsjbRKB5ez4P')
    query = db.cursor(prepared = True)

    UPDATE_DB = """UPDATE `depth_data` SET `Depth` = %s AND 'Ddate' = CURRENT_TIMESTAMP WHERE `depth_data`.`Depth_flume_name` = %s"""
    #UPDATE_DB = """UPDATE `depth_data` SET `Depth` = %s WHERE `depth_data`.`Depth_flume_name` = %s"""
    val = ()
    if basin.basin == 0:
        val = (basin.value, 1)
    elif basin.basin == 1:
        val = (basin.value, 0)
    query.execute(UPDATE_DB, val)
    db.commit()

def main():
    if os.path.exists(DBFILEPATH):
        print("File exists: %s" % DBFILEPATH)
    else:
        print("File doesn't exist: %s" % DBFILEPATH)

    while(True):
        print("Getting new depths")
        DWB = getDepth(0)
        LWF = getDepth(1)

        print("Updating DWB...")
        updateDB(DWB)
        print("done!")
        time.sleep(0.5)

        print("Updating LWF...")
        updateDB(LWF)
        print("done!")
        time.sleep(DB_MONITOR_INTERVAL)

if __name__ == "__main__":
    main()

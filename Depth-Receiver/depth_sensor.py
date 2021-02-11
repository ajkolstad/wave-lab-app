import sys, os, os.path
import mysql.connector
import sqlalchemy as db

from datetime import datetime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import (
    Column,
    Float,
    Integer,
    DateTime
    )

DEBUG = False

Base = declarative_base()
class Data(Base):
    __tablename__ = 'data'
    id = Column(Integer, primary_key=True)
    value = Column(Float, index=True)
    basin = Column(Integer, index=True) # flume=0, basin=1
    datetime = Column(DateTime, index=True)

ARCHIVE = "/a1/walve/data"
FACILITIES = [ "LWF", "DWB"]

# The file path of the sqlite database
# DBFILEPATH = "/a1/walve/data/levels.sqlite"
DBFILEPATH = "levels.sqlite"

def main():
    path = DBFILEPATH
    argv = sys.argv
    
    if len(argv) == 2:
        path = argv[1]
    
    if os.path.exists(path):
        print("File exists: %s" % path)
    else:
        print("File doesn't exist: %s" % path)

    # Create db connection and metadata
    engine = db.create_engine('sqlite:///%s' % path, echo=DEBUG)
    connection = engine.connect()
    metaData = db.MetaData()

    # Load data table
    depths = db.Table('data', metaData, autoload=True, autoload_with=engine)
    Session = sessionmaker(bind = engine)
    session = Session()

    results = session.query(Data).order_by(Data.datetime.desc()).limit(2)
    for row in results:
        print(row.basin, " : ", row.value)


if __name__ == "__main__":
    main()
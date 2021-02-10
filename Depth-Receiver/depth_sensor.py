import sys, os, os.path
import mysql.connector

from datetime import datetime
from sqlalchemy.orm import relation, backref
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import create_engine
from sqlalchemy.orm import (
    scoped_session,
    sessionmaker,
    )

DBSession = scoped_session(sessionmaker())
Base = declarative_base()

# Depth data file path, sub directories DWB and LWF exist
ARCHIVE = "/a1/walve/data"
FACILITIES = [ "LWF", "DWB"]

# The file path of the sqlite database
DBFILEPATH = "/a1/walve/data/levels.sqlite"
HOLD_DATA_FOR = 60 # days
REDUCE_DATA_RESOLUTION_AFTER = 48 # hours 


def main():
    argv=sys.argv
    if len(argv) != 2:
        usage(argv)

    fn = argv[1]
    if os.path.exists(fn):
        print("File exists: %s" % fn)
    else:
        print("File doesn't exist: %s" % fn)

    engine = create_engine('sqlite:///%s' % fn)
    print(engine.table_names)


    DBSession.configure(bind=engine)
    Base.metadata.create_all(engine)
    
    print("successful connect")

if __name__ == "__main__":
    main()

import sys, os, os.path
from datetime import datetime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import create_engine
from sqlalchemy.orm import (
    scoped_session,
    sessionmaker,
    )

DBSession = scoped_session(sessionmaker())
Base = declarative_base()

def usage(argv):
    print('usage: initdb.py <dbfilename>\n') 
    sys.exit(1)
    
def main():
    
    argv=sys.argv
    if len(argv) != 2:
        usage(argv)

    fn = argv[1]
    if os.path.exists(fn):
        sys.exit("File exists: %s" % fn)
    else:
        sys.exit("File doesn't exist: %s" % fn)

    engine = create_engine('sqlite:///%s' % fn)
    DBSession.configure(bind=engine)
    Base.metadata.create_all(engine)

if __name__ == "__main__":
    main()

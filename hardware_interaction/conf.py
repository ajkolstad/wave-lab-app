
# modify as needed

from control import *

# Setup the valve controls
facility_controls = dict(
    LWF=dict(
        flume_north = EPM3_120R_HaywardControl('10.214.152.134', debug=False, title="Flume Valve North"),
        flume_south = EPM2_120R_HaywardControl('10.214.152.135', debug=False, title="Flume Valve South")
    ),
    DWB=dict(
        basin_north = EPM3_120R_HaywardControl('10.214.152.132', debug=False, title="Basin Valve North")
    )
)

# Where are the data files?  The sub directories DWB and LWF are assume to exist.
ARCHIVE = "/a1/walve/data"

# The file path of the sqlite database
DBFILEPATH = "/a1/walve/data/levels.sqlite"

# How long should data be held for in the database
HOLD_DATA_FOR = 60 # days

# When should we change the resolution of the data in the database?
REDUCE_DATA_RESOLUTION_AFTER = 48 # hours 



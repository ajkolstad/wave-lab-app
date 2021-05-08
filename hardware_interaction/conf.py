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
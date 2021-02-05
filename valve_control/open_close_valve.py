"""***************************************************************************
**
** WALVE
**
** Copyright (C) 2013 Northwest Alliance for Computational Science and
** Engineering (NACSE, www.nacse.org), based at Oregon State University.
**
** The design and implementation of Gridserver are available for royalty-free
** adoption and use for non-commercial purposes, by any public or private
** organization. Copyright is retained by NACSE and Oregon State University.
**
** Redistribution of any portion or of any derivative works must include this
** notice. Please address comments or questions about commercial use to
** nacse-questions@nacse.org.
**
***************************************************************************"""

from valve_control.adam import ADAM

class HCStatus(object):
    """  Hayward Control Status object   """
    not_closed = None
    closed = None
    not_open = None
    open = None
    signal1 = None
    signal2 = None
    warning = None
    error = None
    status = None 

    @property
    def can_open(self):
        return 'clos' in self.status

    @property
    def can_close(self):
        return 'open' in self.status

class HaywardControl(object):
    """
    Walve control class accesses an adam module with specific wiring 
    to a Hayward ball valve.

    See specific status wiring in sub classes below.

    Wiring is as follows:

    ADAM input 0: Hayward output B "open"
               1:                C "not open"
               2:                E "closed"
               3:                F "not closed"
    
               4: Adam output 0 -> Sain smart input 1 
               5:             1 ->                  2

    """

    vt = 2.0  # voltage threshold
    
    # Add to states in sub class
    #          status name         open    !open   closed  !closed signal1 signal2                                                     
    states = [
             ('offline',            0,       0,      0,       0,      0,      0 )
             ]

    attrs = ['open', 'not_open', 'closed', 'not_closed', 'signal1', 'signal2']
    abrevattrs = ['open','n_open','closed','n_clos','sig1', 'sig2']
 
    def __init__(self, IP,
                 port=1025, 
                 debug=False,
                 title=None):
        self.adam = ADAM(IP, port=port, debug=debug)
        self.IP = IP
        self.port = port

        self.title = title or "hc %s" % IP

        # make the map from the list of states
        #   ie, map['011011'] = 'closed'
        self.map = {}
        for state in self.states:
            key = "".join(str(i) for i in state[1:])
            self.map[key] = state[0]

        self.debug = debug

    def open(self):
        return self.adam.set_output(0, True)

    def close(self):
        return self.adam.set_output(0, False)

    def golow(self):
        self.adam.set_output(0,False)
        return self.adam.set_output(1,False)

    def status(self):
        
        s = HCStatus()  
        values = self.adam.read_all_channels()
        if not values:
            s.error = "could not read"
            return s

        bools = []
        for i,attr in enumerate(self.attrs):
            b = values[i]>self.vt
            setattr(s, attr, b)
            bools.append(b)

        map_key = "".join(str(int(b)) for b in bools)
        if map_key in self.map:
            s.status = self.map[map_key]
        else:
            s.status = 'unknown'
            s.warning = 'unkown status'

        return s
   
    def print_status_header(self):
        print "\nSTATUS %s:%s" % ( self.IP, self.port )
        print "\t".join(self.abrevattrs + ["status"])

    def print_status(self):
        """
        Prints to the console for debugging purposes
        """
        
        s = HCStatus()        
        values = self.adam.read_all_channels()
        if not values:
            print "  ERROR: could not read"
            return

        vals = []
        bools = []
        for i,attr in enumerate(self.attrs):
            b = values[i]>self.vt
            bools.append(b)
            
            vals.append(str(values[i]) + str(b)[0])

        print " | ".join(vals)," | ",
 
        map_key = "".join(str(int(b)) for b in bools)
        if map_key in self.map:
            status = self.map[map_key]
        else:
            status = 'unknown'
        
        print status            


# south flume
class EPM2_120R_HaywardControl(HaywardControl):

    states = [  #  status name        open    !open   closed  !closed signal1 signal2       
                ('opening requested',  0,       1,      1,       0,      0,      1 ),
                ('opening start',      0,       1,      1,       1,      0,      1 ),  #
                ('opening start',      0,       1,      0,       0,      0,      1 ),  # duplicate
                ('opening',            0,       1,      0,       1,      0,      1 ),
                ('opening end',        1,       1,      0,       1,      0,      1 ),
                ('open',               1,       0,      0,       1,      0,      1 ),  #
                ('open',               1,       0,      0,       0,      0,      1 ),   # duplicate
                ('closing requested',  1,       0,      0,       1,      1,      1 ),
                ('closing start',      0,       0,      0,       1,      1,      1 ),  #   
                ('closing start',      1,       1,      0,       1,      1,      1 ),  # duplicate
                ('closing',            0,       1,      0,       1,      1,      1 ),
                ('closing end',        0,       1,      1,       1,      1,      1 ),
                ('closed',             0,       1,      1,       0,      1,      1 ),  #
                ('closed',             0,       1,      0,       0,      1,      1 ),   # duplicate 
                ('offline',            0,       0,      0,       0,      0,      0 ) 
            ]  
        
# north flume
class EPM3_120R_HaywardControl(HaywardControl):

    states = [  #  status name        open    !open   closed  !closed signal1 signal2
                ('opening requested',  0,       1,      1,       0,      0,      1 ),
                ('opening start',      0,       1,      1,       1,      0,      1 ),
                ('opening',            0,       1,      0,       1,      0,      1 ),
                ('opening',            0,       1,      0,       0,      0,      1 ),
                ('opening end',        1,       1,      0,       0,      0,      1 ),
                ('opening end',        1,       1,      0,       1,      0,      1 ),
                ('open',               1,       0,      0,       1,      0,      1 ),
                ('open',               1,       0,      0,       0,      0,      1 ),   # duplicate
                ('closing requested',  1,       0,      0,       1,      1,      1 ),  #
                ('closing requested',  1,       0,      0,       0,      1,      1 ),  # duplicate
                ('closing start',      0,       0,      0,       1,      1,      1 ),  #  
                ('closing start',      1,       1,      0,       0,      1,      1 ),  # duplicate
                ('closing start',      1,       1,      0,       1,      1,      1 ),  # duplicate
                ('closing',            0,       1,      0,       1,      1,      1 ),
                ('closing end',        0,       1,      1,       1,      1,      1 ),
                ('closed',             0,       1,      0,       0,      1,      1 ),
                ('closed',             0,       1,      1,       0,      1,      1 ),
                ('closed',             1,       1,      1,       0,      1,      1 ),
                ('offline',            0,       0,      0,       0,      0,      0 )
        ]


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

import sys
import socket
from time import sleep
from decimal import Decimal, Invalidcallration

from walve import Timeout

class ADAM(object):
    
    def __init__(self, IP,
                 port=1025,
                 debug=False):
        self.IP = IP
        self.port = port
        self.debug = debug

    def _call(self, path, 
              timeout=2,
              attempts=5,
              buf=1024,
              ):
        i=1
        while i<=attempts:
            try:
                addr=(self.IP, self.port)
                s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
                s.settimeout(timeout)
                s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
                s.bind(('',self.port))

                s.sendto(path,addr)
                indata, inaddr = s.recvfrom(buf)
                return indata
            
            except socket.timeout:
                #print 'timeout'
                i += 1
            
            finally:
                s.close()

        raise Timeout();
 
    def read_all_channels(self):
        response = self._call('#01\r')
        if not response:
            return []

        data = response[1:]
        vals=[]
        for c in range(8):
            d = None
            try:
                d = Decimal(data[c*10:(c+1)*10])
            except InvalidOperation:           
                try:
                    d = Decimal(data[c*7:(c+1)*7])
                except InvalidOperation:
                    pass
            vals.append(d)
        return vals
           
    def print_channels(self, duration=None, interval=0.5):
        """
        duration is in seconds, or None
        """
        print "\t".join("  " + str(d) for d in range(8))
        i = 0
        while 1:
            print "\t".join(str(d) for d in self.read_all_channels())
            if duration is None:
                break

            i += 1
            if duration is not None:
                if i >= duration*(1.0/interval):
                    break

            sleep(interval)
     
    def set_output(self, index, value):
        """
        index is 0 or 1
        value is True (goes to zero) or False (goes to whatever)
        """
        
        if not index in [0,1]:
            raise Exception("Bad DO index.  Should be 0 or 1")
        if not value in [True, False]:
            raise Exception("Bad DO index.  Should be True or False")
        
        val = 0
        if value:
            val = 1
        
        self._call('#01D%s%s\r'%(index,val))



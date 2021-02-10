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

import sys, os, os.path

from pyramid.config import Configurator
from pyramid_beaker import session_factory_from_settings
from sqlalchemy import create_engine

from .views import *
from .auth import Authenticator
from .util import errlog
import walve.model

def main(global_config, **settings):
        
    auth = Authenticator(settings.get("walve.auth.path", ".userpath"))
    settings['authenticator'] = auth
    
    sqlfp = os.path.abspath(os.path.normpath(str(settings.get("walve.db.path"))))
    if not os.path.exists(sqlfp):
        exit("File does not exist: %s" % sqlfp)

    engine = create_engine('sqlite:///%s' % sqlfp)
    walve.model.DBSession.configure(bind=engine)
    settings['engine'] = engine
    
    session_factory = session_factory_from_settings(settings)
    
    config = Configurator(settings=settings, 
                          session_factory = session_factory)
    
    config.include('pyramid_mako')
    config.include('pyramid_beaker')

    config.add_static_view('static', 'static', cache_max_age=3600)
     
    config.add_route('home', '/')
    config.add_route('login', '/login')
    config.add_route('logout', '/logout')
    config.add_route('flume', '/flume')
    config.add_route('ws', '/ws')
    
    config.add_route('LWF', '/LWF')
    config.add_route('DWB', '/DWB')

    config.add_route('data', '/data')
    config.add_route('update_data', '/update_data')
    
    config.add_route('ws_login', '/ws/login')
    config.add_route('ws_logout', '/ws/logout')
    
    config.scan("walved")
    
    app = config.make_wsgi_app()
    return app
    
    

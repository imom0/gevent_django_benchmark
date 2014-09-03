#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os
import multiprocessing


workers = multiprocessing.cpu_count() * 2 + 1
bind = '127.0.0.1:' + os.environ.get('PORT', '32111')
backlog = 1024
max_requests = 1000
timeout = 30
keep_alive = 2
daemon = True
loglevel = 'info'
errorlog = 'gerror.log'
accesslog = 'gaccess.log'
worker_class = 'sync'
pidfile = 'g_sync.pid'

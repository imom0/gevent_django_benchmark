#!/bin/bash


function run_test {
  sleep 2
  wrk -t20 -c500 -d10s "http://127.0.0.1:$PORT/" -s bm.lua | grep "Requests/sec"
}


export PORT=7891
echo 'gunicorn+gvent+pymysql'
PYMYSQL=1 gunicorn -c conf/g_gevent_conf.py myproj.wsgi:application
run_test
kill -INT `cat g_gevent.pid`

export PORT=7892
sleep 3
echo 'gunicorn+gvent+mysql-python'
PYMYSQL=0 gunicorn -c conf/g_gevent_conf.py myproj.wsgi:application
run_test
kill -INT `cat g_gevent.pid`

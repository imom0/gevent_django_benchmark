#!/bin/bash


function get_unused_port {
  export PORT=`netstat -atn | perl -0777 -ne '@ports = /tcp.*?\:(\d+)\s+/imsg ; for $port (32768..61000) {if(!grep(/^$port$/, @ports)) { print $port; last } }'`
}
function run_test {
  sleep 2
  wrk -t20 -c500 -d10s "http://127.0.0.1:$PORT/" -s bm.lua | grep "Requests/sec"
}

get_unused_port
echo 'gunicorn+gvent+pymysql'
PYMYSQL=1 gunicorn -c conf/g_gevent_conf.py myproj.wsgi:application
run_test
kill -INT `cat g_gevent.pid`

get_unused_port
echo 'gunicorn+gvent+mysql-python'
PYMYSQL=0 gunicorn -c conf/g_gevent_conf.py myproj.wsgi:application
run_test
kill -INT `cat g_gevent.pid`

get_unused_port
echo 'gunicorn+sync+pymysql'
PYMYSQL=1 gunicorn -c conf/g_sync_conf.py myproj.wsgi:application
run_test
kill -INT `cat g_sync.pid`

get_unused_port
echo 'gunicorn+sync+mysql-python'
PYMYSQL=0 gunicorn -c conf/g_sync_conf.py myproj.wsgi:application
run_test
kill -INT `cat g_sync.pid`

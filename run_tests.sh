#!/bin/bash


function get_unused_port {
  # ref: http://www.commandlinefu.com/commands/view/7299/find-an-unused-unprivileged-tcp-port
  export PORT=`netstat -atn | perl -0777 -ne '@ports = /tcp.*?\:(\d+)\s+/imsg ; for $port (50768..61000) {if(!grep(/^$port$/, @ports)) { print $port; last } }'`
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

export PORT=7897
echo 'uwsgi+sync+pymysql'
uwsgi --env PYMYSQL=1 -s /tmp/uwsgiaaa.sock --wsgi-file myproj/wsgi.py --master --pidfile=uwsgi.pid --processes 9 --daemonize uwsgi.log --listen 1024
run_test
kill -INT `cat uwsgi.pid`

echo 'uwsgi+sync+mysql-python'
uwsgi --env PYMYSQL=0 -s /tmp/uwsgiaaa.sock --wsgi-file myproj/wsgi.py --master --pidfile=uwsgi.pid --processes 9 --daemonize uwsgi.log --listen 1024
run_test
kill -INT `cat uwsgi.pid`

echo 'uwsgi+gevent+pymysql'
uwsgi --env PYMYSQL=1 --gevent 100 -s /tmp/uwsgiaaa.sock --wsgi-file myproj/gwsgi.py --master --pidfile=uwsgi.pid --processes 9 --daemonize uwsgi.log --listen 1024
run_test
kill -INT `cat uwsgi.pid`

echo 'uwsgi+gevent+mysql-python'
uwsgi --env PYMYSQL=0 --gevent 100 -s /tmp/uwsgiaaa.sock --wsgi-file myproj/gwsgi.py --master --pidfile=uwsgi.pid --processes 9 --daemonize uwsgi.log --listen 1024
run_test
kill -INT `cat uwsgi.pid`

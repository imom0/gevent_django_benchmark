Gunicorn+Django Benckmark
=========================

数据库不在本机:

```
./run_tests.sh
gunicorn+gvent+pymysql
Requests/sec:    422.45
gunicorn+gvent+mysql-python
Requests/sec:    269.16
gunicorn+sync+pymysql
Requests/sec:    136.39
gunicorn+sync+mysql-python
Requests/sec:    133.76
uwsgi+sync+pymysql
Requests/sec:    138.00
uwsgi+sync+mysql-python
Requests/sec:    152.30
uwsgi+gevent+pymysql
Requests/sec:    446.14
uwsgi+gevent+mysql-python
Requests/sec:    338.59
```

数据库为localhost:

```
$ ./run_tests.sh
gunicorn+gvent+pymysql
Requests/sec:    399.58
gunicorn+gvent+mysql-python
Requests/sec:    458.79
gunicorn+sync+pymysql
Requests/sec:    139.96
gunicorn+sync+mysql-python
Requests/sec:    119.46
uwsgi+sync+pymysql
Requests/sec:    128.45
uwsgi+sync+mysql-python
Requests/sec:    125.55
uwsgi+gevent+pymysql
Requests/sec:    440.70
uwsgi+gevent+mysql-python
Requests/sec:    547.82
```

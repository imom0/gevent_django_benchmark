Gevent+Django Benckmark
=========================

安装依赖
--------

```
pip install -r requirements.txt
```

测试工具[wrk](https://github.com/wg/wrk)及nginx。

业务逻辑
--------

这个项目中业务逻辑不复杂，是对现有sns代码的抽象和模拟。
* GET请求对应的动作是在view中HTTP请求一次外部服务，并返回数据库中最新记录，外部服务选择了gitlab的登录页，平均响应时间在35ms左右，数据库记录限定在了20条，返回json。
* POST请求在数据库中新插入一条记录。

测试方法
--------
配置好nginx，监听端口`7897`，并 `uwsgi_pass unix:///tmp/uwsgiaaa.sock`，gunicorn自己选了一个随机端口监听HTTP请求，无需配置nginx。bm.lua中随机选择GET:POST方法中的一种，几率分别是3:1，模拟500并发，持续10s。

```
./run_tests.sh
```

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

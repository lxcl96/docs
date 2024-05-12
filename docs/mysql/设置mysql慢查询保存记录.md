```sql
-- 查询mysql是否开启慢查询
show variables like 'slow_query_log';
-- 查看当前数据库，慢查询的sql总数
show status like '%Slow_queries%';
--  查询mysql慢查询的时间设置
show VARIABLES like 'long_query_time';
-- 开启慢查询
set global slow_query_log=ON;
-- 设置慢查询时间（单位秒）,不会马上生效，需要重启数据库
set global long_query_time=1;
-- 设置慢查询日志保存位置
set global slow_query_log_file='Dmysql5.6querySlowLogslowQuery.log';

-- 查看是否使用索引，及索引的级别
explain select  from `slow_log` where start_time  '20221024 000000';

-- 遇到多列索引失效的情况，可以将所有的查询列联合作为一个索引
alter  table  表名  add  index  索引名(index_name)  (列名1，列名2.......);

```


#!/bin/bash
# 思考每个命令是不是都需要检查???
# 1.mysql备份数据库 testdb 到/home/ly/data/backup/db
# 2.定时每天凌晨2:30
# 3.文件压缩成.tar.gz 并且以日期命令 2021-03-12_testdb.tar.gz并删除原文件
# 4.备份同时检查是否有10天前的备份文件，有就删除
cd /home/ly/data/backup/db/
echo "开始备份mysql-testdb"
now=`date "+%Y-%m-%d"`
mysqldump -u root -p1024 testdb >"${now}_testdb.sql"
if [ $? -ne 0 ]; then
	echo "mysql-testdb备份失败"
	exit 1
fi
if [ -f "${now}_testdb.sql" ]; then
	tar -zcvf "${now}_testdb.tar.gz" ${now}_testdb.sql --remove-files
	if [ $? -ne 0 ]; then
	    echo "mysql-testdb压缩失败"
    	exit 2
	fi
else
	echo "/home/ly/data/backup/db/${now}_testdb.sql不存在！"
	exit 3
fi
# 可以使用 find -atime +10 -name "*.tar.gz" exec rm -rf {} \;筛选出十天前的文件并将其删除
echo "开始清理10天前的备份包..." 
declare time
for file in `ls /home/ly/data/backup/db/`
do
	if [[ $file == *.tar.gz ]]; then
		timeStr=`basename $file _testdb.tar.gz`
		{
			time=`date -d $timeStr "+%s"`
		} || {
			time=`date "+%s"`
		}
		if [ $[`date "+%s"`-$time] -gt 864000 ]; then
			{
				rm -rf /home/ly/data/backup/db/${file}
				echo "10天前文件/home/ly/data/backup/db/${file}删除成功"
			} || {
				echo "10天前文件/home/ly/data/backup/db/${file}删除失败"
			}	
		fi
	fi
done
echo "$now mysql-testdb备份完成"

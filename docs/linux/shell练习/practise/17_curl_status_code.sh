#!/bin/bash
# 练习7：写一个Shell脚本通过curl命令返回的状态码来判定所访问的网站是否正常，比如当前状态码200，才算正常
if [ $# -lt 1 ]; then
	echo "请输入一个网址"
	exit -1
fi
curl -D /tmp/weblog $1 
status_code=`head -1 "/tmp/weblog"|awk '{print $2}'`
echo $status_code
if [ $status_code -eq 200 ]; then
	echo "访问网址 $1 正常"
else
	echo "访问网址 $1 异常"
fi

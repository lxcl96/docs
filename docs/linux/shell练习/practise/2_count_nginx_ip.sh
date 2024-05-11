#!/bin/bash
# 练习2：统计Nginx日志中每个IP的访问量有多少，日志格式如下
# 192.168.56.1 - - [21/May/2018:20:44:06 -0400] "GET /index.html HTTP/1.0" 404 169 "-" "ApacheBench/2.3" "-"/code/index.html
# 答案
# cat |awk '{print $1}'|sort -rn|uniq -c
declare -A arr
for item in `awk '{print $1}' /home/ly/practices/nginx.log`
do
	if [ -z $item ]; then
		arr[$item]=1
		#echo "++++ ${arr[$item]}"
	else
		arr[$item]=$[${arr[$item]} + 1]
		#echo "---- ${arr[$item]}"
	fi
done
#echo ${arr[*]}
#echo ${!arr[*]}
for ip in ${!arr[*]} 
do
	echo "ip ${ip} 出现 ${arr[$ip]} 次"
done

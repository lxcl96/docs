#!/bin/bash
# 练习2：计算nginx日志中访问最多的10个IP使用的流量综合
path=/home/ly/practices/access.log
ip_list=`awk '{print $1}' $path|sort|uniq -c|sort -rn|awk '{print $2}'`

for ip in $ip_list
do
	total=`grep -P '^'$ip'\s-' $path|awk '{{sum+=$10}}END{print sum}'`
	echo "ip=$ip total=$total"
	#echo "地址$ip 总流量$total"
	
done

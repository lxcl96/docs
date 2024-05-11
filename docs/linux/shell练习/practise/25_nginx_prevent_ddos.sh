#!/bin/bash

# 练习3：防止DOS攻击，检测nginx日志，若某个IP短时间的PV过大则使用防火墙将其禁
# 这个规则其实是不确定的,理论上是要求比如1分钟内访问次数100次就禁用,但是实际上实现有困难,一般都算成累积的,好一点的就是只count当天的ip数量
declare threshold=100
declare ban_time=600 # 单位秒
# 用到了awk正则匹配 //中写模式  /也要转义 
# date中+表示读时间字符串 不带+表示设置系统时间
today=`date "+%d\/%b\/%Y"`
ips_of_log=`awk '$4~/'$today'/{ip_list[$1]++}END{for(ip in ip_list) print ip_list[ip]" "ip}' "/usr/local/nginx/logs/access.log"`
while read -r line
do
	pv=`echo $line|awk '{print $1}'`
	ip=`echo $line|awk '{print $2}'`
	echo "ip=$ip  pv=$pv"	
	if [ $pv -ge $threshold ]; then
		echo "警报!!! $ip 访问$pv 次,开始封禁 $ban_time 秒"
		firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.136.1" port protocol="tcp" port="80" reject' --timeout=10m		
	fi
done <<< "$ips_of_log"

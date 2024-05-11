#!/bin/bash
# 练习2：写一个脚本，实现判断10.0.0.0/24网络里，当前在线用户的IP有哪些
declare online_user=""
declare offline_user=""
for((i=0;i<256;i++))
do
	ping "192.168.31.$i" -c 1 -w 1 >/dev/null
	#echo "$i"
	if [ $? -eq 0 ]; then
		online_user="$online_user  192.168.31.$i"
	else
		offline_user="$offline_user  192.168.31.$i"
	fi
done
echo "当前在线用户有 $online_user"
echo "当前离线用户有 $offline_user"

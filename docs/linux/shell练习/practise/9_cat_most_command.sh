#!/bin/bash
# 练习5：写一个Shell脚本来看看你使用的最多的命令是哪些，列出你最常用的命令top10 history已经写入history.log文件
# 答案 history|awk '{print $2}'|sort|uniq -c|sort -rn|head -n 10

# 注意yum install firefox 命令应该算yum 而不是整体

# 下面自己写的有问题不用看
unique_list=`awk '{print $2}' "/home/ly/practices/history.log"|sort -u`

for i in $unique_list
do
	#正则不对,因为文件格式是 100 yum install firefox 
	count=`grep -c ^$i$ "/home/ly/practices/history.log"`
	echo "命令 $i 使用 $count 次"
done

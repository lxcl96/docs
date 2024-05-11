#!/bin/bash
# 练习3：写一个脚本计算一下Linux系统所有进程占用内存的大小的和
# %MEM列是进程占用物理内存的百分比。可以通过查看该值来了解进程所使用的物理内存比例大小。
# VSZ(Virtual Memory Size)是虚拟内存的大小，表示进程所使用的虚拟内存空间大小。
# RSS(Resident Set Size)是进程实际使用的物理内存大小，即占用的内存数，单位为KB。
# 我们求RSS的和

# 答案
# ps aux|awk NR!=1'{print $6}'|grep -v ^0$|awk '{sum+=$1}END{print sum}'
declare total=0
for size in `ps -aux|awk '{print $6}'` # 第一行要去掉
do
	total=$[$size+$total]
done
echo "所有进程一共占用内存$total KB"

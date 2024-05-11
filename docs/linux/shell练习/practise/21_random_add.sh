#!/bin/bash
# 练习1：生成0-100之间的随机数，并相加，直到大于1000，输出相加的结果
declare num=0
declare sum=0
while [ $sum -le 1000 ]
do
	num=$[$RANDOM%101]
	echo "random=$num"
	sum=$[$sum+$num]
done
echo "sum=$sum"

#!/bin/bash
#练习6：编写一个脚本，计算100以内所有能被3整除数字的和
sum=0
for i in `seq 1 100`
do
	if [ $[$i % 3] -eq 0 ]; then
		sum=$[$sum+$i]
	fi
done
echo "所有能被3整除数字的和为: $sum"

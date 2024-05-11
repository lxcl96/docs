#!/bin/bash
# 练习5：写一个猜数字脚本，当用户输入的数字和预设数字（随机生成一个0-100的数字）一样时，退出，否则让用户一直输入，并且提示用户的数字比预设数字大或者小
declare input=-1
target=$[$RANDOM%101]
read -p "请输入您的数字: " input
#echo '$target='$target
if [ $target -eq $input ];then
	echo "恭喜您猜中了$target"
else
	while [ 1 ]
	do
		if [ $target -eq $input ]; then
			echo "恭喜您猜中了$target"
			exit 0
		elif [ $input -lt $target ]; then
			echo "很遗憾您猜错了! $input 比目标数字小."
		else
			echo "很遗憾您猜错了! $input 比目标数字大."
		fi
		read -p "请重新输入您的数字: " input
	done
fi

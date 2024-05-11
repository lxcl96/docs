#!/bin/bash
# 练习1：输入两个整数计算这两个整数的相加，相减，相乘，相除，求余的结果。

# 答案:

echo "$1 + $2 =$(awk "BEGIN{print $1+$2}")"
echo "$1 - $2 =$(awk "BEGIN{print $1-$2}")"
echo "$1 * $2 =$(awk "BEGIN{print $1*$2}")"
echo "$1 / $2 =$(awk "BEGIN{print $1/$2}")"
echo "$1 % $2 =$(awk "BEGIN{print $1%$2}")"

if [ $# -ne 2 ]; then
	echo "参数输入不正确"
	exit -1
fi
echo "$1 + $2 =$[$1+$2]"
echo "$1 - $2 =$[$1-$2]"
echo "$1 * $2 =$[$1*$2]"
echo "$1 / $2 =$[$1/$2]"
echo "$1 % $2 =$[$1%$2]"


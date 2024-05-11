#!/bin/bash
# 练习1：将下面的条件表达式，写成if条件语句
# [ -f /etc/hosts ] && echo !

if [ -f /etc/hosts ]; then
	echo !
fi

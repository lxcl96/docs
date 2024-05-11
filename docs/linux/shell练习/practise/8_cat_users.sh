#!/bin/bash
# 练习4：写一个Shell，看看linux系统中是否有自定义用户（普通用户），若是有，一共有几个？
# 答案
# $(awk -F: '$3>=1000 && $1!="nobody" {print $1}' /etc/passwd | wc -l)

awk -F: '{if($3>999 && $3<65534) print $1" "$3}' /etc/passwd|wc -l

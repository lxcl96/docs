#!/bin/bash
#练习1：按照时间生成文件"2018-05-22.log"将每天的磁盘使用状态写入到对应日期的文件
now=`date "+%Y-%m-%d"`
iostat >/tmp/ly_log/${now}.log

# 答案
# df -h >/tmp/ly_log/${now}.log

#!/bin/bash
# 练习4：使用 ps aux 查看系统进程发现有100个test.sh脚本正在运行，如何杀死所有的test.sh

#kill `ps -ef|grep 'baidu.com'|grep -v 'grep'|awk '{print $2}'`
# 参考答案
ps aux|grep baidu.com|awk '{print $2}'|xargs kill

#!/bin/bash
# 练习2：查看磁盘、当前使用状态，如果使用率超过80%则把结果输出到/var/log/disk.err
declare threshold=10
df -h|awk 'NR!=1{if($5>$threshold) print $0}'

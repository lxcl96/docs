#!/bin/bash
# 练习4：实时监控服务器CPU使用率大于80%，磁盘使用率大于80%，内存使用率大于80%时报警

# cpu
cpu=`sar -u 1 1|grep Average|awk '{print 100-$8}'`
echo "cpu利用率为$cpu %"
mem=`free|awk '/Mem/{printf "%.2f",$3/$2*100}'`
echo "内存占用率为$mem"
disk=`df|awk '/\/$/{print $5}'`
echo "磁盘使用率$disk"

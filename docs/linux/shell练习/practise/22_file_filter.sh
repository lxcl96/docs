#!/bin/bash
# 练习3：判断/tmp/目录下是否有大于4K的文件，如果有则输出该文件的大小与创建时间



# 参考答案
find /home/ly/tdgw-1.4.10 -type f -size +4k -printf "文件名%p文件大小%s字节 创建时间%TY-%Tm-%Td %TH:%TM:%TS \n" 
# 我的答案
#ls -l /home/ly/tdgw-1.4.10/|grep ^-|awk '{if($5>4096) print $5" "$6" "$7" "$8" "$9}'

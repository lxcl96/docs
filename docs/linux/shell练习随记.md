# 0. 练习题地址

[【运维知识高级篇】34道Shell编程练习题及答案（从基础到实战：基础+计算+判断+循环+控制与数组+实战进阶）（一）-阿里云开发者社区 (aliyun.com)](https://developer.aliyun.com/article/1303891?spm=a2c6h.14164896.0.0.7a3f47c5CFasNF&scm=20140722.S_community@@文章@@1303891._.ID_1303891-RL_34道shell-LOC_search~UND~community~UND~item-OR_ser-V_3-P0_0)

[【运维知识高级篇】34道Shell编程练习题及答案（从基础到实战：基础+计算+判断+循环+控制与数组+实战进阶）（二）-阿里云开发者社区 (aliyun.com)](https://developer.aliyun.com/article/1303892)

# 1. cat nginx.log|aws '{print $1}'|sort -rn|uniq -c

# 2. shell关联数组使用

+ `${arr[*]}`或`${arr[@]}` 获取数组的所有元素
+ `${#arr[*]}`或`${#arr[@]}`获取数组个数
+ `${!arr[*]}`或`$[!arr[@]]`获取数组所有键值

# 3. ps aux|awk NR!=1'{print $6}'|grep -v ^0$|awk '{sum+=$1}END{print $1}'

# 5. awk 'BEGIN{print 1+2}'

# 6. sed -i -e '6,10s/[A-Za-z]//g' /home/ly/practices/nginx.log;sed -i -e '1,5{/[A-Za-z]/d}' /home/ly/practices/nginx.log

# 7. echo "I am koten I am 18"|awk '{for(i=1;i<=NF;i++){ret=match($i,"^[A-Za-z]{1,2}$")?$i:"";if(ret) {print $i}}}'

# 8. awk -F: '{if($3>999 && $3<65534) print $1" "$3}' /etc/passwd|wc -l

# 9. ==history|awk '{print $2}'|sort|uniq -c|sort -rn|head -n 10==

关键: `uniq -c`然后`sort -rn`

# 13. 单词排序

## 13.1 按照单词出现频率降序排序

+ `echo "the squid project provides a number of resources toassist users design,implement and support squid installations. Please browsethe documentation and support sections for more infomation"|sed -e 's/,/ /g'|sed -e 's/\./ /g'|awk '{for(i=1;i<=NF;i++)print $i}'|sort|uniq -c|sort -rn`
+ 等价于 `echo "the squid project provides a number of resources toassist users design,implement and support squid installations. Please browsethe documentation and support sections for more infomation"|sed -e 's/[,.]/ /g'|awk '{for(i=1;i<=NF;i++)print $i}'|sort|uniq -c|sort -rn`
+ 等价于`echo "the squid project provides a number of resources toassist users design,implement and support squid installations. Please browsethe documentation and support sections for more infomation"|sed -e  's/[,.]/ /g'|awk '{for(i=1;i<=NF;i++)arr[$i]++}END{for(item in arr) print arr[item]" "item}'|sort -rn`

## 13.2 按照字母出现频率降序排序

+ `echo "the squid project provides a number of resources toassist users design,implement and support squid installations. Please browsethe documentation and support sections for more infomation"|grep -o [A-Za-z]|sort|uniq -c|sort -n`

# 14. kill \`ps -ef|grep baidu.com|grep -v grep|awk '{print $2}'\`或者 ps aux|grep baidu.com|grep -v grep|awk '{print $2}'|xargs kill

`xargs [选项] 命令`

最重要的就是`xargs` 用于给后面的命令传递参数 ,一般配合管道符使用

# 16.grep -P '^\\D\*?[0-9]\\D\*?$' nginx.log

重点使用`-p` 开启perl模式

# 17. curl -s -o /dev/null -w "%{http_code}" www.baidu.com

+ `-s` 安静模式,不输出进度条
+ `-o` 将返回内容输入到指定文件
+ `-w` 表示获取请求响应的具体值,`http_code`代表响应状态码.其余的看man帮助

# 18. df -h|awk 'NR!=1{if($5>80) print $0}'

# 19. echo 1024|passwd --stdin tom

+ `useradd -p`不生效,除非指定的是加密后的密文
+ 函数调用不需要加`()`
+ 函数定义在使用之前

# 22. find /tmp -type f -size +4k -printf "文件名%p,文件大小%s字节,创建时间%TY-%Tm-%d %TH:%TM:%TS"

+ **找文件优先用`find`**
+ `find`各个参数使用方法

# 25. firewall-cmd -add-rich-rule='rule family="ipv4" source address="192.168.136.1" port protocol="tcp" port="80" reject' --timeout=10m

含义:禁止192.168.136.1访问服务的80端口,时常是10分钟

+ 如果使用`--permanent`则必须跟上`firewall-cmd --reload`才能是新规则立马生效
+ 如果使用`--timeout`则规则立马生效,千万不要执行`firewall-cmd --reload`否则会导致新加的带`timeout`规则立马失效
+ 对应使用`--timeout`的rich rule,新连接立马生效,已经建立的连接要过一会才能生效



# 26,获取系统状态

+ 内存 `ps -aux` 或`free`
+ cpu `ps -aux`或`asr -u [interval] [count]`
+ 磁盘 `df -h`

# * 遗忘点

+ 关联数组**取全部值,取全部键**?
+ 变量字符串比较 **操作符两边是否要有空格**?
+ 关联数组类型的变量,如何通过**变量键**取出对应值?
+ 统计的话记住要用关联数组
+ awk 输出其实就是循环,**如果是输出的值再循环打印就多次一举了(后果每个数输出10次)**
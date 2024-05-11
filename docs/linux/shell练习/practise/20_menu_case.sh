#!/bin/bash
:<<!
打印一个菜单如下，然后使用循环加case语句输出用户输入菜单选项的结果
h 显示命令帮助
f 显示登陆信息
d 显示磁盘挂载
m 查看内存使用
u 查看系统负载
q 退出程序
!
function tips(){
	echo "-----------------------tips-------------"
	echo "h 显示帮助信息"
	echo "f 显示登录信息"
	echo "d 显示磁盘挂载"
	echo "m 查看内存使用"
	echo "u 查看系统负载"
	echo "q 退出程序"
	echo "-----------------------tips-------------"
}
declare command=0
while [ ${command} != "q" ]
do
	read -p "请输入命令:" command
	case $command in
		"h")
			tips
		;;
		"f")
			who
		;;
		"d")
			df -h
		;;
		"m")
			free -h
		;;
		"u")
			uptime
		;;
		"q")
			echo  "程序即将退出..."
		;;
		*)
			echo "命令$command 无法识别! 输入h可以查看帮助信息!"
	esac
	#echo $command
done


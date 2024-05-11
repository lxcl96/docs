#!/bin/bash
# 练习3：脚本批量创建10个用户，需要对用户输入密码是否为数字和输入的名字是否为空做判断

echo "脚本批量创建10个用户-开始"
function user_passwd(){
    read -p "请输入用户 $1 的密码:" password
    if [[ !($password =~ ^[0-9]+$) ]]; then
        echo "密码只允许为数字!"
        user_passwd $1
	else
		useradd $1 && echo $password|passwd --stdin $1
		if [ $? -eq 0 ];then
			echo "+++++congratulation! 用户$1 创建成功!"
		else
			echo "-----sorry! 用户$1 创建失败"
		fi
    fi
}
function user_add(){
    read -p "请输入要创建的用户名:" user
    if [ -z $user ]; then
        echo "用户名不允许为空!"
        user_add
    else
        user_passwd $user
    fi
}
for i in `seq 10`
do
    user_add
done


echo "脚本批量创建10个用户-结束"


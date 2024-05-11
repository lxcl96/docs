#!/bin/bash
#练习4：在/backup下创建10个.txt的文件，找到/backup目录下所有后缀名是.txt的文件
# 批量修改txt为txt.bak，把所有的.bak文件内打包压缩为123.tar.gz，批量还原文件的名字，把增加的.bak删除掉


# 答案
cd /home/ly/practices/backup
if [ -z $1]; then
	tar -zxvf 123.tar.gz
	for file in `ls|grep ".*\.txt\.bak"`
	do
    	mv $file ${file/.bak/}
	done
else
	fileList=" "
	for file in `ls|grep ".*\.txt"`
	do
		mv $file $file".bak" 
		fileList=$fileList" "$file".bak"
	done
	tar -zcvf "123.tar.gz" $fileList --remove-files
fi



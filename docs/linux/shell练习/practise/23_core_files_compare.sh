#!/bin/bash
# 检测服务器中重要文件是否被修改(自定义),如果修改就报警(使用指纹--即md5)
declare -A core_files=(
	["/home/ly/practices/nginx.log"]="15a1f34f44011ae1c375852c6d9dd974"
	["/home/ly/practices/nginx.log.bak"]="d36058f34e963b7da1d23c0a5060faec"
	["/home/ly/practices/disk.err"]="871187cc8e52eed8455fdd0f7a2961d1"
)

for file in ${!core_files[@]}
do
	#echo ${core_files[$file]}
	figer=`md5sum $file|awk '{print $1}'`
	if [ ${core_files[$file]} != $figer ]; then
		echo "警报!!  文件 ${file} 已被修改原指纹是${core_files[$file]},新指纹是$figer"
	fi
done

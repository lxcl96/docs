#!/bin/bash
# 练习2：把一个文本文档的前五行中包含字母的行删掉，同时把6到10行中全部字母删掉
sed -i -e '6,10s/[A-Za-z]//g' /home/ly/practices/nginx.log
sed -i -e '1,5{/[A-Za-z]/d}' /home/ly/practices/nginx.log

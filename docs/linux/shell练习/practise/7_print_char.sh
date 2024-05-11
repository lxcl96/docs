#!/bin/bash
# 练习3：打印下面这句话中字母数小于3的单词，I am koten I am 18

# 答案
# cho "I am koten I am 18"|awk '{ for(i=1; i<=NF; i++) { if (length($i) < 3) print $i } }'
echo "I am koten I am 18"|awk '{for(i=1;i<=NF;i++){ret=match($i,"^[A-Za-z]{1,2}$")?$i:"";if(ret) {print $i}}}'

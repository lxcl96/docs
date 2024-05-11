#!/bin/bash
# 练习3：用shell处理以下内容，按单词出现频率降序排序，按字母出现频率降序排序。
# the squid project provides a number of resources toassist users design,implement and support squid installations. Please browsethe documentation and support sections for more infomation

# 答案
words='the squid project provides a number of resources toassist users design,implement and support squid installations. Please browsethe documentation and support sections for more infomation'

echo "按照单词出现的频率降序排序"
echo ${words}|sed -e 's/,/ /g'|sed -e 's/\./ /g'|awk '{for(i=1;i<=NF;i++) print $i}'|sort|uniq -c|sort -rn
echo "按照单词出现的频率降序排序--参考答案"
echo "$words" | awk '{ for(i=1; i<=NF; i++) { count[$i]++ } } END { for(word in count) { print count[word], word } }' | sort -rn

echo "按照字母出现频率降序排序"
echo $words|grep -o '[A-Za-z]'|sort|uniq -c|sort -rn
echo "按照字母出现频率降序排序--参考答案"
echo "$words" | grep -o . | grep -v '[. ]' | sort | uniq -c | sort -rn

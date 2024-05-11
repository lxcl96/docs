#!/bin/bash
# 练习6： 用Shell实现，把一个文本文档中只有一个数字的行给打印出来
grep -P '^\D*?[0-9]\D*?$' nginx.log.bak

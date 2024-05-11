#!/bin/bash

declare -A ip=(
	["192.168.0.1"]=1
	["127.0.0.1"]=2
)

echo "${ip[127.0.0.1]}"

for i in "$ip"
do
	echo "++  "$i
done

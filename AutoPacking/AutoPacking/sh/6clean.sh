#!/bin/sh

__OutputFile1=$1
__OutputFile2=$2
__OutputFile3=$3
__OutputFile4=$4

# 从Xcode运行需要先cd到当前目录
if [ ! -n "$5" ] ;then
    echo "you have not input a word!"
else
    cd $5
fi



# 循环3次清空所有改动
for i in $(seq 1 3)
do
    __CommitId=`git rev-parse HEAD`
    git reset --hard $__CommitId
    git clean -d -f
done

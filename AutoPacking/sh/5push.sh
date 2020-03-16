#!/bin/sh

# 从Xcode运行需要先cd到当前目录
if [ ! -n "$2" ] ;then
    echo "you have not input a word!"
else
    cd $2
fi


git commit -m "$1" PackingLog.txt 热更新发包记录.txt
git push


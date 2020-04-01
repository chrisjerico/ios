#!/bin/sh


__Version=$1


# 从Xcode运行需要先cd到当前目录
if [ ! -n "$2" ] ;then
    echo "you have not input a word!"
else
    cd $2
fi


# 删除旧的压缩包
rm -rf *.zip

# 压缩
zip -q -r "$__Version.zip" ./*

#!/bin/sh

# 从Xcode运行需要先cd到当前目录
if [ ! -n "$1" ] ;then
    echo "you have not input a word!"
else
    cd $1
fi


cd ..
cd ..

git clean -d -fx
git pull




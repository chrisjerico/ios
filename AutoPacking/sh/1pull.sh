#!/bin/sh

# 从Xcode运行需要先cd到当前目录
if [ ! -n "$1" ] ;then
    echo "you have not input a word!"
else
    cd $1
fi



# 循环10次拉取代码，直到已经是最新代码
for i in $(seq 1 10)
do
    __CommitId=`git rev-parse HEAD`
    git reset --hard $__CommitId
    git clean -d -fx
    __Result=`git pull`

    echo $__Result;
    if [ "$__Result" == "Already up to date." ];then
        # 已是最新代码
        git rev-parse --short HEAD > CommitId.txt
        echo "开始打包时间：`date '+%Y-%m-%d %T'`" >> PullSuccess.txt
        echo "————————————————————————————————————" >> PullSuccess.txt
        echo "当前 commit：`git rev-parse --short HEAD`" >> PullSuccess.txt
        echo "————————————————————————————————————\n\n\n" >> PullSuccess.txt
        echo "————————————————————————————————————" >> PullSuccess.txt
        echo "前3条提交日志：" >> PullSuccess.txt
        echo "————————————————————————————————————\n" >> PullSuccess.txt
        git log -3 >> PullSuccess.txt
        break;
    fi
done

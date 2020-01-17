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
        git shortlog -1 > ShortLog.txt
        echo "CommitId = `git rev-parse --short HEAD`" >> PullSuccess.txt
        echo "————————————————————————————————————\n\n\n" >> PullSuccess.txt
        git log -10 --oneline >> PullSuccess.txt
        break;
    fi
done


# 判断是否拉取成功
if [ ! -f 'CommitId.txt' ]; then
    echo "拉取代码失败，请手动拉取代码！" > PullFail.txt
fi

# 把提交次数作为版本号
echo `git rev-list HEAD|wc -l` > Version.txt

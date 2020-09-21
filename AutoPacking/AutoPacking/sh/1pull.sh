#!/bin/sh

__OutputFile1=$1
__OutputFile2=$2
__OutputFile3=$3
__OutputFile4=$4

__Path=$5
__Branch=$6

# 先cd到目录
cd $__Path

# 配置环境变量
export PATH=/usr/local/bin:$PATH

# —————— 切换到指定分支 start
# 1. 删除改动
__CommitId=`git rev-parse HEAD`
git reset --hard $__CommitId
git clean -d -f
git reset --hard $__CommitId
# 2. 切换分支
git checkout -b $__Branch origin/$__Branch
git checkout $__Branch
# 3. 拉取最新代码
__CommitId=`git rev-parse origin/$__Branch`
git reset --hard $__CommitId
git clean -d -f
git reset --hard $__CommitId
git pull

__Result=`git checkout $__Branch`
echo $__Result
if [[ "$__Result" =~ "Your branch is up to date with 'origin/$__Branch'." ]]
then
    echo "\n———————— 切换 $__Branch 分支成功 ————————\n"
else
    echo "\n———————— 切换 $__Branch 分支错误 ————————\n"
    exit 1
fi
# —————— 切换到指定分支 end


# 再拉一次最新代码
git clean -d -f
__Result=`git pull`

if [ "$__Result" == "Already up to date." ];then
    # 已是最新代码
    git rev-parse --short HEAD > $__OutputFile1
    git shortlog -1 > $__OutputFile2
    echo `git rev-list HEAD|wc -l` > $__OutputFile3
    echo `git log --oneline -1`
    echo "当前 $__Branch 已是最新代码"

    # 重新安装rn依赖库
    echo '\n———————— 正在 yarn install... ————————\n'
    yarn install > null
    echo '\n———————— 已完成 yarn install ————————\n'
fi


#!/bin/sh

__OutputFile1=$1
__OutputFile2=$2
__OutputFile3=$3
__OutputFile4=$4

__Environment=$5


# 配置环境变量
export PATH=/usr/local/bin:$PATH

# 查看指定APP的包信息
code-push deployment ls "$__Environment" > $__OutputFile1

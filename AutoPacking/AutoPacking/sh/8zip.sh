#!/bin/sh

__OutputFile1=$1
__OutputFile2=$2
__OutputFile3=$3
__OutputFile4=$4

__Path=$5
__Version=$6


cd $__Path

# 删除旧的压缩包
rm -rf *.zip

# 压缩
zip -q -r "$__Version.zip" ./*

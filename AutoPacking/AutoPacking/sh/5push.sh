#!/bin/sh

__OutputFile1=$1
__OutputFile2=$2
__OutputFile3=$3
__OutputFile4=$4

__Path=$5
__Title=$6

cd $__Path


git commit -m "$__Title" PackingLog.txt RN发包记录.txt Images.json
git push

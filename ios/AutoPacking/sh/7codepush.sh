#!/bin/sh


__Version=$1
__Log=$2


# 从Xcode运行需要先cd到当前目录
if [ ! -n "$3" ] ;then
    echo "you have not input a word!"
else
    cd $1
fi


#【Bundle打包】
react-native bundle --entry-file index.ios.js --bundle-output ./bundle/main.jsbundle --platform ios --assets-dest ./bundle --dev false

#【发布更新】
code-push release-react ug ios --t $__Version --des "$__Log"

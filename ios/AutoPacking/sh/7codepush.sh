#!/bin/sh


__APPVersion=$1
__Version=$2
__Log=$3
__KeyFile=$4


# 从Xcode运行需要先cd到当前目录
if [ ! -n "$5" ] ;then
    echo "you have not input a word!"
else
    cd $5
fi


# 随便改点东西（要是跟上个包一摸一样会提交不成功）
git "console.log('123');" >> js/rn/UpdateVersion.js

#echo $PATH
export PATH=/usr/local/bin:$PATH
#echo $PATH


# 删除依赖库
rm -rf node_modules

# 重新安装依赖库
yarn install

#【Bundle打包】
react-native bundle --entry-file index.ios.js --bundle-output ./bundle/main.jsbundle --platform ios --assets-dest ./bundle --dev false > rn打包结果.txt

# 发布到测试环境（私钥签名）
code-push release-react UGiOS ios --t $__APPVersion --des "$__Version" -k $__KeyFile
# 发布到正式环境
#code-push release-react UGiOS ios --t $__APPVersion --dev false --d Production --des "$__Version" --m true
# 把测试环境的更新包推送到正式环境
#code-push promote UGiOS Staging Production
